import SwiftUI

struct Boom: View {
    let diameter: CGFloat
    let degree: CGFloat
    let center: CGPoint
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 3, height: diameter * 0.274)
                .foregroundColor(.red)
                .offset(x: 0, y: -diameter * 0.135)
                .rotationEffect(Angle(degrees: degree))
            
            Circle()
                .frame(width: 3, height: 3)
                .foregroundColor(.red)
        }
        .position(x: center.x, y: center.y - diameter * 0.1)
    }
}

#Preview {
    GeometryReader { geometry in
        let diameter = min(geometry.size.width,geometry.size.height)
        let center = CGPoint(
            x: geometry.size.width / 2,
            y: geometry.size.height / 2
        )
        Boom(diameter: diameter, degree: 30, center: center)
    }
}
