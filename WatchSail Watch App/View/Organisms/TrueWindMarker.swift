//
//  TrueWindMarker.swift
//  Sail
//
//  Created by 박세진 on 10/23/24.
//

import SwiftUI

struct TrueWindMarker: View {
    let diameter: CGFloat
    let degree: CGFloat
    let windOffset: CGFloat
    var body: some View {
        Image(systemName: "pencil.tip")
            .resizable()
            .scaledToFit()
            .frame(width: diameter * 0.08)
            .rotationEffect(Angle(degrees: 180))
            .overlay {
                VStack {
                    Text("T")
                        .fontDesign(.monospaced)
                        .font(.system(size: diameter * 0.05))
                        .bold()
                    Spacer()
                }
            }
            .offset(x: 0, y: -diameter * 0.45)
            .foregroundColor(.mint)
            .rotationEffect(Angle(degrees: degree + windOffset))
    }
}

#Preview {
    GeometryReader { geometry in
        let diameter = min(geometry.size.width, geometry.size.height)
        let center = CGPoint(
            x: geometry.size.width / 2,
            y: geometry.size.height / 2
        )
        
        TrueWindMarker(diameter: diameter, degree: 30, windOffset: 30)
            .position(center)
    }
}
