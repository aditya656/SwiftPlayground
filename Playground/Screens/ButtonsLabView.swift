//
//  ButtonsLabView.swift
//  Playground
//
//  Created by Aditya Patole on 16/08/25.
//

import SwiftUI

struct ButtonsLabView: View {
    @State private var count = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Buttons Lab").font(.title)
            Button("Tap me (\(count))") { count += 1 }
                .buttonStyle(.borderedProminent)
            Button(role: .destructive) { count = 0 } label: {
                Label("Reset", systemImage: "arrow.counterclockwise")
            }
            GlowPillButton(title: "Tap Me", kind: .Primary) {
                print("Tapped!")
            }
            .padding()
            .frame(width: Constants.Screen.width)
            
            GlowPillButton(title: "Tap Me", kind: .Secondary) {
                print("Tapped!")
            }
            .frame(width: Constants.Screen.width)
        }
        .padding(100)
        .background(Color.white.opacity(0.05))
    }
}

struct GlowPillButton: View {
    let title: String
    var kind: ButtonKind
    @State private var isPressed = false
    let action: () -> Void
    @State private var touchPoint = CGPoint.zero
    
    // Tune these to taste
    private let glowDiameter: CGFloat = 260
    let primaryColor: Color
    
    init(title: String, kind: ButtonKind = .Primary, action: @escaping () -> Void) {
        self.title = title
        self.kind = kind
        self.action = action
        
        self.primaryColor = kind == .Primary ? .blue : .clear
    }
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            ZStack {
                // Background
                primaryColor
                    .clipShape(Capsule())
                    .brightness(isPressed ? 0.2 : 0)
                
                // Moving glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.2),
                                Color.white.opacity(0.0)
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
                Capsule().stroke(Color.white.opacity(0.5), lineWidth: 1)
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
                        touchPoint = CGPoint(
                            x: min(max(0, value.location.x), size.width),
                            y: min(max(0, value.location.y), size.height)
                        )
                    }
                    .onEnded { value in
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
    }
}

enum ButtonKind {
    case Primary
    case Secondary
}
