import SwiftUI
import Combine
import CoreLocation

class RecordingManager: ObservableObject {
    @Published var currentSession: Session = Session(startTime: Date())
    private var timer: AnyCancellable?
    
    func startRecording() {
        currentSession = Session(startTime: Date()) // 새 세션 생성
        objectWillChange.send() // UI에 변경 사항 알림
        print("Recording started.")
        startTimer()
    }
    
    func stopRecording() {
        timer?.cancel()
        timer = nil
        currentSession.endTime = Date() // 세션 종료 시간 설정
        print("Recording stopped. Session saved with \(currentSession.count) data points.")
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 10, on: .main, in: .common) // 테스트를 위해 10초로 설정
            .autoconnect()
            .sink { [weak self] _ in
                self?.saveDataPoint()
            }
    }
    
    private func saveDataPoint() {
        let location = LocationData(latitude: 37.7749, longitude: -122.4194, timestamp: Date())
        let weather = WeatherData(temperature: 20.0, windSpeed: 5.0, windDirection: 90.0, timestamp: Date())
        let trueWind = Wind(speed: 10.0, direction: 45.0, type: .trueWind)
        let apparentWind = Wind(speed: 8.0, direction: 90.0, type: .apparentWind)
        
        let dataPoint = DataPoint(location: location, weather: weather, trueWind: trueWind, apparentWind: apparentWind, timestamp: Date())
        currentSession.addDataPoint(dataPoint)
        objectWillChange.send() // UI에 변경 사항 알림
        print("Saved DataPoint at \(Date()) - Total count in session: \(currentSession.count)")
    }
}

