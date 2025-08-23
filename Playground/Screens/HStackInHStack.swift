//
//  HStackInHStack.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//



import SwiftUI

struct HStackInHStack: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                HStack(spacing: 4) {
                    Text("Favourite")
                        .background(Color.random)
                    Text("New")
                        .background(Color.random)
                }
                .background(Color.random)
                Text("10")
            }
            .background(Color.random)
            HStack(spacing: 10) {
                HStack(spacing: 4) {
                    Text("Hide")
                        .background(Color.random)
                    Text("New")
                        .background(Color.random)
                }
                .background(Color.random)
                Text("10")
            }
            .background(Color.random)
        }
    }
}

#Preview {
    HStackInHStack()
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
