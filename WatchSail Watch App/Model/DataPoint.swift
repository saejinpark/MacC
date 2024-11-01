import Foundation
import SwiftData

//@Model
class DataPoint: ObservableObject {
    var location: LocationData
    var weather: WeatherData
    var trueWind: Wind
    var apparentWind: Wind
    var timestamp: Date

    init(location: LocationData, weather: WeatherData, trueWind: Wind, apparentWind: Wind, timestamp: Date) {
        self.location = location
        self.weather = weather
        self.trueWind = trueWind
        self.apparentWind = apparentWind
        self.timestamp = timestamp
    }
}
