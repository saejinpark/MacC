import Foundation
import SwiftData

//@Model
class WeatherData: ObservableObject {
    var temperature: Double
    var windSpeed: Double
    var windDirection: Double
    var humidity: Double?
    var pressure: Double?
    var timestamp: Date

    init(temperature: Double, windSpeed: Double, windDirection: Double, humidity: Double? = nil, pressure: Double? = nil, timestamp: Date) {
        self.temperature = temperature
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.humidity = humidity
        self.pressure = pressure
        self.timestamp = timestamp
    }
}

