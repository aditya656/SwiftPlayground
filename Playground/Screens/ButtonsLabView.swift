//
//  ButtonsLabView.swift
//  Playground
//
//  Created by Aditya Patole on 16/08/25.
//

import SwiftUI

struct ButtonsLabView: View {
    @State private var count = 0
    @State private var isPressed = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Buttons Lab").font(.title)
            Button("Tap me (\(count))") { count += 1 }
                .buttonStyle(.borderedProminent)
            Button(role: .destructive) { count = 0 } label: {
                Label("Reset", systemImage: "arrow.counterclockwise")
            }
            GlowPillButton(title: "Tap Me", isPressed: $isPressed) {
                print("Tapped!")
            }
            .padding()
            .frame(width: Constants.Screen.width)
        }
        .padding(100)
        .background(Color.white.opacity(0.05))
    }
}

struct GlowPillButton: View {
    let title: String
    @Binding var isPressed: Bool
    let action: () -> Void
    @State private var touchPoint = CGPoint.zero
    
    // Tune these to taste
    private let glowDiameter: CGFloat = 260
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            ZStack {
                // Background
                Color.blue
                    .clipShape(Capsule())
                    .brightness(isPressed ? 0.2 : 0)
                
                // Moving glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.blue.opacity(0.2),
                                Color.blue.opacity(0.0)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: glowDiameter / 2
                        )
                    )
                    .enableHDR()
                    .brightness(isPressed ? 1 : 0)
                    .frame(width: glowDiameter, height: glowDiameter)
                    .position(touchPoint)                // follows finger
                    .clipShape(Capsule())
                    .clipped()                       // keep inside pill
                    .allowsHitTesting(false)
                    .opacity(isPressed ? 1 : 0)
                    .transition(.opacity)
                
                // Label
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .brightness(isPressed ? 0.3 : 0)
            }
            .overlay(
                Capsule().stroke(Color.blue, lineWidth: 1)
                    .brightness(isPressed ? 0.4 : 0)
            )
            .scaleEffect(isPressed ? 1.07 : 1)
            .contentShape(Capsule()) // hit area matches pill
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !isPressed {
                            withAnimation(.easeOut(duration: 0.3)) {
                                isPressed = true
                            }
                        }
                        // Update position (clamped)
                        let s = size
                        touchPoint = CGPoint(
                            x: min(max(0, value.location.x), s.width),
                            y: min(max(0, value.location.y), s.height)
                        )
                    }
                    .onEnded { value in
                        let inside = rect(for: size).contains(value.location)
                        withAnimation(.easeOut(duration: 0.3)) {
                            isPressed = false
                        }
                        if CGRect(origin: .zero, size: size).contains(value.location) {
                            action()
                        }
                    }
            )
        }
        .frame(height: 48) // fixed height; width adapts to content
        .background(
            // This background expands the geometry reader to intrinsic width
            Text(title)
                .font(.headline)
                .opacity(0)
        )
    }
    
    // Helpers
    private func rect(for size: CGSize) -> CGRect { .init(origin: .zero, size: size) }
    private func clamped(_ p: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: min(max(0, p.x), size.width),
            y: min(max(0, p.y), size.height)
        )
    }
}
