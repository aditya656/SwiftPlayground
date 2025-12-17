//
//  MotionEffectView.swift
//  Playground
//
//  Created by Aditya Patole on 04/12/25.
//

import SwiftUI

struct MotionEffectView<Content: View>: UIViewRepresentable {
    var magnitude: CGFloat
    let content: Content

    init(magnitude: CGFloat, @ViewBuilder content: () -> Content) {
        self.magnitude = magnitude
        self.content = content()
    }

    func makeUIView(context: Context) -> UIView {
        let hostingController = UIHostingController(rootView: content)
        let view = hostingController.view!

        // Horizontal Motion
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude

        // Vertical Motion
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude

        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
        view.backgroundColor = .clear  // So SwiftUI background stays intact

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct MotionEffect: ViewModifier {
    let magnitude: CGFloat
    
    func body(content: Content) -> some View {
        MotionEffectView(magnitude: magnitude) {
            content
        }
    }
}

extension View {
    func motionEffect(magnitude: CGFloat) -> some View {
        self.modifier(MotionEffect(magnitude: magnitude))
    }
}
