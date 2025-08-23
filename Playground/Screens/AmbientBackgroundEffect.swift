//
//  AmbientBackgroundEffect.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//



import SwiftUI

struct AmbientBackgroundEffect: View {
    let images = [
        ImageItem(name: "img1"),
        ImageItem(name: "img2"),
        ImageItem(name: "img3"),
        ImageItem(name: "img4"),
        ImageItem(name: "img5"),
        ImageItem(name: "img6")
    ]
    @State private var topInset: CGFloat = 0
    @State private var scrollOffsetY: CGFloat = 0
    @State private var scrollProgressX: CGFloat = 0
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                HeaderView()
                    .background(Color.red)
//                    .padding()
                CarouselView()
                    .zIndex(-1)
            }
        }
//        .overlay(
//            Text("scrollProgressX: \(scrollProgressX)")
//                .padding()
//                .background(Color.white)
//                .cornerRadius(8)
//                .shadow(radius: 4),
//            alignment: .top
//        )
        .safeAreaPadding(15)
        .background {
            Rectangle()
                .fill(.black.gradient)
                .scaleEffect(y: -1) /// Flipping in vertical axis
                .ignoresSafeArea()
        }
        .onScrollGeometryChange(for: ScrollGeometry.self) {
            $0
        } action: { oldValue, newValue in
            topInset = newValue.contentInsets.top + 100
            scrollOffsetY = newValue.contentOffset.y + newValue.contentInsets.top
        }
    }
    
    @ViewBuilder
    func BackdropCarouselView() -> some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                ForEach(images.reversed()) { model in
                    let index = CGFloat(images.firstIndex(where: { $0.id == model.id }) ?? 0) + 1
                    
                    Image(model.name)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                        .opacity(index - scrollProgressX)
                }
            }
            .compositingGroup()
            .blur(radius: 30, opaque: true)
            .overlay {
                Rectangle()
                    .fill(.black.opacity(0.35))
            }
            ///             Progressive Masking
            .mask {
                Rectangle()
                    .fill(.linearGradient(colors: [
                        .black,
                        .black,
                        .black,
                        .black,
                        .black.opacity(0.5),
                        .clear
                    ], startPoint: .top, endPoint: .bottom))
            }
        }
        .containerRelativeFrame(.horizontal)
        .padding(.bottom, -60)
        .padding(.top, -topInset)
        .offset(y: scrollOffsetY < 0 ? scrollOffsetY : 0)
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Image(systemName: "xbox.logo")
                .font(.system(size: 35))
            VStack(alignment: .leading, spacing: 6) {
                Text("Aditya")
                    .font(.callout)
                    .fontWeight(.semibold)
                HStack(spacing: 6) {
                    Image(systemName: "g.circle.fill")
                    Text("36,990")
                        .font(.caption)
                }
            }
            Spacer(minLength: 0)
            Image(systemName: "square.arrow.up.circle.fill")
                .font(.largeTitle)
            Image(systemName: "bell.circle.fill")
                .font(.largeTitle)
        }
        .foregroundStyle(.white, .fill)
    }
    
    @ViewBuilder
    func CarouselView() -> some View {
        let spacing: CGFloat = 6
        
        ScrollView(.horizontal) {
            LazyHStack(spacing: spacing) {
                ForEach(images) { model in
                    Image(model.name)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .containerRelativeFrame(.horizontal)
                        .frame(height: 380)
                        .clipShape(.rect(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
                        
                }
                
            }
            .scrollTargetLayout()
        }
        .frame(height: 380)
        .background(BackdropCarouselView())
        .scrollTargetLayout()
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        .onScrollGeometryChange(for: CGFloat.self) {
            let offsetX = $0.contentOffset.x + $0.contentInsets.leading
            let width = $0.containerSize.width + spacing
            
            return offsetX / width
        } action: { oldValue, newValue in
            let maxValue = CGFloat(images.count - 1)
            scrollProgressX = min(max(newValue, 0), maxValue)
        }

    }
}

#Preview {
    AmbientBackgroundEffect()
}
