//
//  DragGestureBootcamp.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//



import SwiftUI

struct DragGestureBootcamp: View {
    @State var offset: CGSize = .zero
    @State var velocity: CGSize = .zero
    
    var body: some View {
        ZStack {
            VStack {
                Text("\(offset.width)")
                Text("\(offset.height)")
                Text("Velocity: \(velocity.width)")
                Spacer()
            }
            RoundedRectangle(cornerRadius: 24.0, style: .circular)
                .frame(width: 300, height: 500)
                .offset(offset)
                .scaleEffect(getScaleValue())
//                .rotationEffect(Angle(degrees: getRotationEffect()))
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            velocity = value.velocity
                            offset = value.translation
                        })
                        .onEnded({ value in
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                velocity = .zero
                                withAnimation(.spring) {
                                    offset = .zero
                                }
//                            }
                        })
                )
        }
    }
    
    private func getScaleValue() -> CGFloat {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = abs(offset.width)
        let percentage = currentAmount / max
        
        return 1.0 - min(percentage, 0.1) / 2
    }
    
    private func getRotationEffect() -> Double {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = offset.width
        let percentage = currentAmount / max
        let percentDoubleValue = Double(percentage)
        let maxAngle: Double = 10
        return percentDoubleValue * maxAngle
    }
    
/*trigger back navigation:
 offset width > 150
 velocity > 2000
 */
}

#Preview {
    DragGestureBootcamp()
}
