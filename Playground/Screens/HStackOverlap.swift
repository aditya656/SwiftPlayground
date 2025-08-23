//
//  HStackOverlap.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//



import SwiftUI

struct HStackOverlap: View {
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .stroke(.red, lineWidth: 5)
            Rectangle()
                .stroke(.green, lineWidth: 5)
            Rectangle()
                .stroke(.yellow, lineWidth: 5)
            Rectangle()
                .stroke(.purple, lineWidth: 5)
            Rectangle()
                .stroke(.blue, lineWidth: 5)
        }
        .frame(height: 200)
    }
}

#Preview {
    HStackOverlap()
}
