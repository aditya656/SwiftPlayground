//
//  AnimatableCornerRadiusShape.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//



import SwiftUI

struct AnimatableCornerRadiusShape: View {
    @State var scaleAnimation: Bool = false
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundStyle(Color.black)
                .frame(width: scaleAnimation ? 200 : 100, height: scaleAnimation ? 200 : 100)
                .clipShape(RoundedCornerShape(
                    topLeft: scaleAnimation ? 24 : 12,
                    topRight: scaleAnimation ? 24 : 12,
                    bottomLeft: scaleAnimation ? 24 : 12,
                    bottomRight: scaleAnimation ? 24 : 12))
                .animation(.easeInOut, value: scaleAnimation)
            Spacer()
            Button {
                scaleAnimation.toggle()
            } label: {
                Text("Animate!")
            }
        }
        .frame(maxHeight: 350)
    }
}

#Preview {
    AnimatableCornerRadiusShape()
}

struct RoundedCornerShape: Shape {
    var topLeft: CGFloat
    var topRight: CGFloat
    var bottomLeft: CGFloat
    var bottomRight: CGFloat

    // Comment this computed property to know the difference
    // Combine all four corner radii into a single animatable data tuple
    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>> {
        get {
            AnimatablePair(
                AnimatablePair(topLeft, topRight),
                AnimatablePair(bottomLeft, bottomRight)
            )
        }
        set {
            topLeft = newValue.first.first
            topRight = newValue.first.second
            bottomLeft = newValue.second.first
            bottomRight = newValue.second.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        
        // Start at top-left corner
        path.move(to: CGPoint(x: rect.minX + topLeft, y: rect.minY))
        
        // Top side
        path.addLine(to: CGPoint(x: rect.maxX - topRight, y: rect.minY))
        path.addArc(withCenter: CGPoint(x: rect.maxX - topRight, y: rect.minY + topRight),
                    radius: topRight,
                    startAngle: .pi * 1.5,
                    endAngle: 0,
                    clockwise: true)
        
        // Right side
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight))
        path.addArc(withCenter: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY - bottomRight),
                    radius: bottomRight,
                    startAngle: 0,
                    endAngle: .pi * 0.5,
                    clockwise: true)
        
        // Bottom side
        path.addLine(to: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY))
        path.addArc(withCenter: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY - bottomLeft),
                    radius: bottomLeft,
                    startAngle: .pi * 0.5,
                    endAngle: .pi,
                    clockwise: true)
        
        // Left side
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeft))
        path.addArc(withCenter: CGPoint(x: rect.minX + topLeft, y: rect.minY + topLeft),
                    radius: topLeft,
                    startAngle: .pi,
                    endAngle: .pi * 1.5,
                    clockwise: true)
        
        path.close()
        
        return Path(path.cgPath)
    }
}
