//
//  LazyVGridBootcamp.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//



import SwiftUI

struct LazyVGridBootcamp: View {
    
    let columns: [GridItem] = [
//        GridItem(.flexible(), spacing: 1.0),
//        GridItem(.flexible(), spacing: 1.0)
        GridItem(spacing: 1),
        GridItem(spacing: 1),
        GridItem(spacing: 1)
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1, content: {
                ForEach(0..<50) { index in
                    Rectangle().frame(height: 300)
                }
            })
        }
    }
}

#Preview {
    LazyVGridBootcamp()
}
