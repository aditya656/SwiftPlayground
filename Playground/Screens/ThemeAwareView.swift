//
//  ThemeAwareView.swift
//  Playground
//
//  Created by Aditya Patole on 21/03/26.
//
import SwiftUI

struct ThemeAwareView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var typeSize
    @Environment(\.locale) var locale
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        Text("Hello")
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .onAppear {
                print("---- test print")
            }
            .onChange(of: scenePhase) { newPhase, _ in
                // Monitoring the app's lifecycle changes
                switch newPhase {
                case .active:
                    print("App is active")
                case .inactive:
                    print("App is inactive")
                case .background:
                    print("App is in the background")
                @unknown default:
                    print("Unknown state")
                }
            }
    }
}
