//
//  CompassView.swift
//  WatchSail
//
//  Created by 박세진 on 10/30/24.
//

import SwiftUI

struct CompassView: View {
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        ZStack {
            // 배경 원
            Circle()
                .stroke(lineWidth: 4)
                .foregroundColor(.gray)
                .frame(width: 200, height: 200)
            
            
            // 나침반 바늘
            Rectangle()
                .fill(Color.red)
                .frame(width: 2, height: 90)
                .offset(y: -45)
                .rotationEffect(Angle(degrees: -(locationManager.heading?.trueHeading ?? 0)))
            
            
            Rectangle()
                .fill(Color.red)
                .frame(width: 2, height: 90)
                .offset(y: -45)
                .rotationEffect(Angle(degrees: -(locationManager.heading?.magneticHeading ?? 0)))

            // 나침반의 중심점
            Circle()
                .fill(Color.black)
                .frame(width: 10, height: 10)
            Text("\(-(locationManager.heading?.trueHeading ?? 0))")
        }
    }
}

#Preview {
    CompassView()
}
