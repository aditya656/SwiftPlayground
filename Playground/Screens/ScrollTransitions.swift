//
//  ScrollTransitions.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//



import SwiftUI

struct ScrollTransitions: View {
    let images = [
        ImageItem(name: "img1"),
        ImageItem(name: "img2"),
        ImageItem(name: "img3"),
        ImageItem(name: "img4"),
        ImageItem(name: "img5"),
        ImageItem(name: "img6")
    ]
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    ForEach(images) { image in
                        Image(image.name, bundle: nil)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 220, height: size.height)
                            .clipShape(.rect(cornerRadius: 25))
                            .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                content
                                    .blur(radius: phase == .identity ? 0: 2, opaque: false)
                                    .scaleEffect(phase == .identity ? 1 : 0.9, anchor: .bottom)
                                    .offset(y: phase == .identity ? 0 : 35)
                            }
                    }
//                    .padding(.horizontal, (size.width - 220) / 2)
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)//(.viewAligned(limitBehavior: .always))
                .safeAreaPadding(.horizontal, (size.width - 220) / 2)
            }
            .frame(height: 330)
        }
    }
}

#Preview {
    ScrollTransitions()
}

struct ImageItem: Identifiable {
    let id = UUID()
    let name: String
}
