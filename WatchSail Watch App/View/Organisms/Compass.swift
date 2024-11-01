//
//  Compass.swift
//  Sail
//
//  Created by 박세진 on 10/23/24.
//

import SwiftUI

struct Compass: View {
    let diameter: CGFloat
    let compassDegree: CGFloat
    
    var body: some View {
        ZStack {
            let dir = ["N", "E", "S", "W"]
            ForEach(0..<dir.count, id: \.self) { index in
                let dirString = dir[index]
                Text(dirString)
                    .font(.system(size: diameter * 0.05))
                    .bold()
                    .foregroundColor(dirString != "N" ? .white : .red)
                    .offset(x: 0, y: -diameter * 0.34)
                    .rotationEffect(
                            Angle(degrees: Double(index) * 90)
                        )
                
            }
            ForEach(0..<12, id: \.self) { index in
                if index * 30 % 90 != 0 {
                    Rectangle()
                        .frame(width: 1, height: 10)
                    .offset(x: 0, y: -diameter * 0.34)
                    .rotationEffect(
                        Angle(degrees: Double(index) * 30)
                    )
                }
            }
        }
        .rotationEffect(Angle(degrees: compassDegree))
    }
}

#Preview {
    GeometryReader { geometry in
        let diameter = min(geometry.size.width, geometry.size.height)
        let center = CGPoint(
            x: geometry.size.width / 2,
            y: geometry.size.height / 2
        )
        
        Compass(diameter: diameter, compassDegree: 30)
            .position(center)
    }
    .preferredColorScheme(.dark)
}
