import Foundation
import WeatherKit
import Combine
import CoreLocation

class WeatherManager: NSObject, ObservableObject {
    static let shared = WeatherManager()
    
    private let weatherService = WeatherService()
    let locationManager = LocationManager.shared
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var weather: Weather?
    
    private var lastWeatherFetchTime: Date?
    private let weatherUpdateInterval: TimeInterval = 5 * 60 // 5분 간격
    private var isFirstFetch = true // 처음 위치 업데이트를 위한 플래그
    
    private override init() {
        super.init()
        setupWeatherUpdates()
    }
    
    private func setupWeatherUpdates() {
        // LocationManager의 lastLocation이 변경될 때마다 날씨 정보를 업데이트
        locationManager.$lastLocation
            .compactMap { $0 } // 위치가 nil이 아니면 실행
            .filter { [weak self] newLocation in
                self?.shouldFetchWeather(for: newLocation) ?? false
            }
            .sink { [weak self] location in
                Task {
                    await self?.fetchWeatherData(for: location)
                }
            }
            .store(in: &cancellables)
    }
    
    private func shouldFetchWeather(for location: CLLocation) -> Bool {
        if isFirstFetch {
            isFirstFetch = false
            return true // 처음 위치 업데이트 시 바로 날씨 정보를 가져오기
        }
        
        // 마지막 업데이트 시간 체크
        if let lastFetchTime = lastWeatherFetchTime {
            let elapsedTime = Date().timeIntervalSince(lastFetchTime)
            if elapsedTime < weatherUpdateInterval {
//                print("Weather update skipped: Too soon since last update.")
                return false
            }
        }
        
        return true
    }
    
    private func fetchWeatherData(for location: CLLocation) async {
        do {
            let weather = try await weatherService.weather(for: location)
            
            DispatchQueue.main.async {
                self.weather = weather
                self.lastWeatherFetchTime = Date() // 마지막 업데이트 시간 기록
//                print("Updated Weather Data:")
//                print("Wind Speed: \(weather.currentWeather.wind.speed.value) m/s")
//                print("Wind Direction: \(weather.currentWeather.wind.direction.value)°")
//                print("Temperature: \(weather.currentWeather.temperature.value)°C")
            }
        } catch {
//            print("Failed to fetch weather data: \(error.localizedDescription)")
        }
    }
}

extension WeatherManager {
    
    // True Wind (실제 바람 속도 및 방향)
    var trueWind: (speed: Double, direction: Double)? {
        guard let currentWeather = weather?.currentWeather else { return nil }
        return (
            speed: currentWeather.wind.speed.value, // m/s
            direction: currentWeather.wind.direction.value // degrees
        )
    }
    
    // Apparent Wind (보이는 바람 속도 및 방향)
    var apparentWind: (speed: Double, direction: Double)? {
        guard let trueWind = trueWind,
              let boatSpeed = locationManager.lastLocation?.speed,
              let boatDirection = locationManager.lastLocation?.course else {
            return nil
        }
        
        // 보트가 정지 상태일 경우 apparentWind는 trueWind와 동일하게 설정
        if boatSpeed == 0 || boatDirection == -1 {
            return trueWind
        }
        
        // apparentWind 계산 (단순화된 공식 예시)
        let windAngleRelativeToBoat = (trueWind.direction - boatDirection).truncatingRemainder(dividingBy: 360)
        let apparentWindSpeed = sqrt(pow(trueWind.speed, 2) + pow(boatSpeed, 2) +
                                     2 * trueWind.speed * boatSpeed * cos(windAngleRelativeToBoat * .pi / 180))
        let apparentWindDirection = (atan2(
            trueWind.speed * sin(windAngleRelativeToBoat * .pi / 180),
            boatSpeed + trueWind.speed * cos(windAngleRelativeToBoat * .pi / 180)
        ) * 180 / .pi + boatDirection).truncatingRemainder(dividingBy: 360)
        
        return (speed: apparentWindSpeed, direction: apparentWindDirection)
    }
}
