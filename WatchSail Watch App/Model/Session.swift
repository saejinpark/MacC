import Foundation
import SwiftData

//@Model
class Session: ObservableObject {
    @Published var dataPoints: [DataPoint] = []
    var startTime: Date
    var endTime: Date?
    
    var count: Int {
        return dataPoints.count
    }

    init(startTime: Date, endTime: Date? = nil) {
        self.startTime = startTime
        self.endTime = endTime
    }
    
    func addDataPoint(_ dataPoint: DataPoint) {
        dataPoints.append(dataPoint)
        objectWillChange.send() // 수동으로 변경 사항 전송
    }
}
