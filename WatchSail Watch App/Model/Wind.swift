import Foundation
import SwiftData

//@Model
class Wind: ObservableObject {
    var speed: Double
    var direction: Double
    var type: WindType
    
    init(speed: Double, direction: Double, type: WindType) {
        self.speed = speed
        self.direction = direction
        self.type = type
    }
}
