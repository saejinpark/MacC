//
//  CompassManagerTestView.swift
//  WatchSail Watch App
//
//  Created by 박세진 on 10/31/24.
//

import SwiftUI

struct PhoneHeadingReceiverTestView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @ObservedObject var receiver = PhoneHeadingReceiver.shared
    
    var body: some View {
        VStack {
            VStack {
                Text(receiver.heading.isNaN ? "Heading: --" : "Heading: \(receiver.heading, specifier: "%.2f")°")
                    .font(.headline)
                
                // 화살표 방향을 표시하는 간단한 UI 예제
                Image(systemName: "arrow.up")
                    .rotationEffect(Angle(degrees: receiver.heading.isNaN ? 0 : receiver.heading))
                    .font(.largeTitle)
                    .padding()
                
                if let location = locationManager.lastLocation {
                    Text("Course: " + (location.course.isNaN ? "--" : "\(location.course)°"))
                    if !location.course.isNaN {
                        Image(systemName: "arrow.up")
                            .rotationEffect(Angle(degrees: -location.course))
                            .font(.largeTitle)
                            .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    PhoneHeadingReceiverTestView()
}
