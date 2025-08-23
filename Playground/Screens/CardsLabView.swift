//
//  CardsLabView.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//

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
