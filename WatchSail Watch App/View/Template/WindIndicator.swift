//
//  WindIndicator.swift
//  WatchSail Watch App
//
//  Created by 박세진 on 10/31/24.
//

import SwiftUI

struct WindIndicator: View {
    let course: Double
    let compassDegree: Double
    let windOffset: Double
    let trueWindDegree: Double
    let apparentWindDegree: Double
    let boomAngle: Double
    
    var body: some View {
        
        GeometryReader { geometry in
            let diameter = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
            )
            ZStack {
                Yacht()
                    .frame(width: diameter / 2)
                    .foregroundColor(.blue)
                    .rotationEffect(Angle(degrees: course))
                
                Compass(diameter: diameter, compassDegree: -compassDegree)
                    .position(center)
                
                TrueWindMarker(diameter: diameter, degree: trueWindDegree - compassDegree, windOffset: windOffset)
                
                ApparentWindMarker(diameter: diameter, degree: apparentWindDegree - compassDegree, windOffset: windOffset)
                
                Boom(diameter: diameter, degree: boomAngle - course - compassDegree, center: center)
                    .rotationEffect(Angle(degrees: course))
                    
            }
            .rotationEffect(Angle(degrees: -course))
            Circle()
                .stroke(.white, lineWidth: 1)
                .position(center)
        }
    }
}

#Preview {
    WindIndicator(
        course: 45,               // 배의 진행 방향
        compassDegree: 90,        // 나침반 방위
        windOffset: 10,           // 바람 표시 위치 오프셋
        trueWindDegree: 120,      // 실제 바람 방향
        apparentWindDegree: 150,  // 체감 바람 방향
        boomAngle: 30             // Boom 각도
    ).ignoresSafeArea()
}
