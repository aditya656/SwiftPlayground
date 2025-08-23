//
//  Extensions.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//


import SwiftUI

extension Color {
    static var dynamicBackground: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        })
    }
}

extension View {
    func enableHDR() -> some View {
        background(
            Color.clear
                .onAppear {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
//                        window.layer.wantsExtendedDynamicRangeContent = true // deprecated
                        window.layer.preferredDynamicRange = .high
                    }
                }
        )
    }
}
