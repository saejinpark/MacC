import Foundation
import SwiftData

//@Model
class LocationData: ObservableObject {
    var latitude: Double
    var longitude: Double
    var altitude: Double?
    var timestamp: Date
    
    init(latitude: Double, longitude: Double, altitude: Double? = nil, timestamp: Date) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.timestamp = timestamp
    }

}
