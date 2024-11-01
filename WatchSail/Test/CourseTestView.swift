import SwiftUI

struct CourseTestView: View {
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Course Test View")
                .font(.title)
                .padding()
            
            // Course 표시
            if let location = locationManager.lastLocation {
                Text("Course: \(location.course.isNaN ? "--" : "\(location.course, specifier: "%.2f")°")")
                    .font(.headline)
                
                Image(systemName: "arrow.up")
                    .rotationEffect(Angle(degrees: location.course.isNaN ? 0 : -location.course))
                    .font(.largeTitle)
                    .padding()
            } else {
                Text("Location data not available")
                    .font(.headline)
            }
        }
        .padding()
    }
}

#Preview {
    CourseTestView()
}
