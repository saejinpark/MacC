//
//  Yacht.swift
//  Sail
//
//  Created by 박세진 on 10/23/24.
//

import SwiftUI

struct Yacht: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(
                    to: CGPoint(
                        x: geometry.size.width / 2,
                        y: 0
                    )
                )
                
                path.addQuadCurve(
                    to: CGPoint(
                        x: geometry.size.width * (4 / 6),
                        y: geometry.size.height * (5 / 6)
                    ),
                    control: CGPoint(
                        x: geometry.size.width * (4 / 6),
                        y: geometry.size.height * (2 / 8)
                    )
                )
                
                path.addQuadCurve(
                    to: CGPoint(
                        x: geometry.size.width * (2 / 6),
                        y: geometry.size.height * (5 / 6)
                    ),
                    control: CGPoint(
                        x: geometry.size.width / 2,
                        y: geometry.size.height
                    )
                )
                
                path.addQuadCurve(
                    to: CGPoint(
                        x: geometry.size.width / 2,
                        y: 0
                    ),
                    control: CGPoint(
                        x: geometry.size.width * (2 / 6),
                        y: geometry.size.height * (2 / 8)
                    )
                )
                
                path.closeSubpath()
            }
            .stroke(.white, style: StrokeStyle(lineWidth:  2))
        }
        .scaledToFit()
    }
}

#Preview {
    Yacht()
        .frame(width: 100, height: 100)
        .preferredColorScheme(.dark)
}
