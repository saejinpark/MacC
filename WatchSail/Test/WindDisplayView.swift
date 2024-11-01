import SwiftUI

struct WindDisplayView: View {
    @ObservedObject var weatherManager = WeatherManager.shared

    var body: some View {
        VStack {
            Text("Wind Information")
                .font(.title)
                .padding()
            
            ZStack {
                // 나침반 배경 원
                Circle()
                    .stroke(lineWidth: 4)
                    .foregroundColor(.blue)
                    .frame(width: 200, height: 200)
                
                // True Wind 바늘 (녹색)
                if let trueWind = weatherManager.trueWind {
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 2, height: 80)
                        .offset(y: -40)
                        .rotationEffect(Angle(degrees: -trueWind.direction)) // trueWind 방향
                        .animation(.easeInOut, value: trueWind.direction)
                    
                    Text("True Wind: \(String(format: "%.1f", trueWind.speed)) m/s")
                        .offset(y: -120)
                        .foregroundColor(.green)
                } else {
                    Text("True Wind data unavailable")
                        .foregroundColor(.gray)
                }
                
                // Apparent Wind 바늘 (빨간색)
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 2, height: 80)
                    .offset(y: -40)
                    .rotationEffect(Angle(degrees: -(weatherManager.apparentWind?.direction ?? 0))) // apparentWind 방향
                    .animation(.easeInOut, value: weatherManager.apparentWind?.direction ?? 0)

                Text("Apparent Wind: \(String(format: "%.1f", weatherManager.apparentWind?.speed ?? 0)) m/s")
                    .offset(y: 120)
                    .foregroundColor(.red)
                
                // 중심점 표시
                Circle()
                    .fill(Color.black)
                    .frame(width: 10, height: 10)
            }
            .padding()
        }
    }
}

#Preview {
    WindDisplayView()
}
