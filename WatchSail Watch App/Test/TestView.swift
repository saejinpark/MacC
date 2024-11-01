import SwiftUI
import CoreLocation
import Combine

struct TestView: View {
    @ObservedObject private var locationManager = LocationManager.shared
    @ObservedObject private var weatherManager = WeatherManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Location & Weather Info")
                .font(.largeTitle)
                .padding()
            
            // Displaying the last location coordinates
            if let location = locationManager.lastLocation {
                VStack {
                    Text("Latitude: \(location.coordinate.latitude)")
                    Text("Longitude: \(location.coordinate.longitude)")
                }
                .font(.headline)
            } else {
                Text("Location not available")
            }
            
            Text(locationManager.locationName)
            
            // Displaying the heading
            if let heading = locationManager.heading {
                Text("Heading: \(heading.trueHeading, specifier: "%.2f")°")
                    .font(.headline)
            } else {
                Text("Heading not available")
            }
            
            Divider()
            
            // Displaying the weather data
            if let weather = weatherManager.weather {
                VStack {
                    Text("Temperature: \(weather.currentWeather.temperature.value, specifier: "%.1f")°C")
                    Text("Wind Speed: \(weather.currentWeather.wind.speed.value, specifier: "%.1f") m/s")
                    Text("Wind Direction: \(weather.currentWeather.wind.direction.value, specifier: "%.1f")°")
                }
                .font(.headline)
            } else {
                Text("Weather data not available")
            }
        }
        .padding()
    }
}

#Preview {
    TestView()
}
