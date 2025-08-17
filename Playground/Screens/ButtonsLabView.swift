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
        }.padding()
    }
}

// Screens/CardsLabView.swift

import SwiftUI

struct CardsLabView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<10) { i in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThickMaterial)
                        .frame(height: 120)
                        .overlay(Text("Card \(i)").font(.headline))
                        .padding(.horizontal)
                }
            }.padding(.top)
        }
    }
}

// Screens/UIKitDemoViewController.swift

import UIKit

final class UIKitDemoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        let label = UILabel()
        label.text = "UIKit demo screen"
        label.font = .preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
