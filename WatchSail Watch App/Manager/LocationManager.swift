import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    @Published var lastLocation: CLLocation?
    @Published var heading: CLHeading?
    @Published var locationName: String = ""
    
    override private init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.headingFilter = kCLHeadingFilterNone // 모든 헤딩 변화 감지
        locationManager.headingOrientation = .portrait // 나침반 보정을 위한 방향 설정
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
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.lastLocation = location
            self.fetchLocationName(for: location) // 위치 이름 업데이트
//            print("Updated Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            self.heading = newHeading
//            print("Updated heading: \(newHeading.trueHeading)")
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
