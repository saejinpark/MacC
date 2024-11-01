import Foundation
import CoreLocation
import Combine
import WatchConnectivity

class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    @Published var lastLocation: CLLocation?
    @Published var heading: CLHeading?
    @Published var locationName: String = ""
    
    override private init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone // 모든 이동 감지
        locationManager.headingFilter = kCLHeadingFilterNone // 모든 헤딩 변화 감지
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() // 실시간 위치 업데이트 시작
        locationManager.startUpdatingHeading()  // 헤딩 업데이트도 시작
    }
    
    func setDistanceFilter(_ distance: CLLocationDistance) {
        locationManager.distanceFilter = distance // CLLocationManager의 distanceFilter 설정
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation() // 필요할 때 위치 업데이트 중지
        locationManager.stopUpdatingHeading()  // 필요할 때 헤딩 업데이트 중지
    }
    
    private func fetchLocationName(for location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Failed to get location name: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.locationName = "Unknown Location"
                }
                return
            }
            
            if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    self.locationName = placemark.locality ?? "Unknown Location"
                }
            } else {
                DispatchQueue.main.async {
                    self.locationName = "Unknown Location"
                }
            }
        }
    }
    
    private func sendHeadingToWatch(_ heading: CLLocationDirection) {
        guard WCSession.default.isReachable else { return }
        WCSession.default.sendMessage(["heading": heading], replyHandler: nil, errorHandler: { error in
            print("Failed to send heading to watch: \(error.localizedDescription)")
        })
    }
}

// CLLocationManagerDelegate와 WCSessionDelegate 구현부
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.lastLocation = location
            if location.course.isNaN {
                print("Course is unavailable. Device may not be moving.")
            } else {
                print("Updated Course: \(location.course)°")
            }
            self.fetchLocationName(for: location) // 위치 이름 업데이트
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            self.heading = newHeading
            self.sendHeadingToWatch(newHeading.trueHeading) // Apple Watch로 heading 전송
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation() // 위치 업데이트 자동 재개
        case .denied, .restricted:
            print("Location access denied or restricted.")
        default:
            break
        }
    }
}

extension LocationManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession did deactivate")
        WCSession.default.activate() // 필요 시 재활성화 시도
    }
}
