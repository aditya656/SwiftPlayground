//
//  OverlayBlurView.swift
//  Playground
//
//  Created by Aditya Patole on 25/08/25.
//
import SwiftUI

struct OverlayBlurView: View {
    @State private var showOverlay = false

    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            Image(systemName: "xbox.logo")
                .resizable()
                .frame(width: 100, height: 100)
//                .blur(radius: showOverlay ? 6 : 0)
            if showOverlay {
//                Color.white
//                    .opacity(0.2)
//                    .transition(.opacity)   // 👈 apply opacity transition
                BackdropBlur(radius: 6)
                    .transition(.opacity)
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                showOverlay.toggle()
            }
        }
    }
}

#Preview {
    OverlayBlurView()
}
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct BackdropBlur: View {
    var radius: CGFloat
    
    var body: some View {
        // This draws a transparent layer but applies a blur filter to whatever is behind
        Rectangle()
            .fill(Color.clear)
            .background(.regularMaterial) // fallback if filter isn't supported
            .background(
                Canvas { context, size in
                    context.addFilter(.blur(radius: radius))
                }
            )
            .allowsHitTesting(false)
    }
}
