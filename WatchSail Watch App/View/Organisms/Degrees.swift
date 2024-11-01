//
//  Degrees.swift
//  Sail
//
//  Created by 박세진 on 10/23/24.
//

import SwiftUI

struct Degrees: View {
    let diameter: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(0...72, id: \.self) { index in
                Rectangle()
                    .frame(width: 1, height: diameter * 0.05)
                    .foregroundColor(.white)
                    .offset(x: 0, y: diameter * 0.34)
                    .rotationEffect(.degrees(Double(index) * 6))
            }
        }
    }
}

#Preview {
    GeometryReader { geometry in
        let diameter = min(geometry.size.width, geometry.size.height)
        let center = CGPoint(
            x: geometry.size.width / 2,
            y: geometry.size.height / 2
        )
        Degrees(diameter: diameter)
            .position(x: center.x, y: center.y)
    }
    .preferredColorScheme(.dark)
}
