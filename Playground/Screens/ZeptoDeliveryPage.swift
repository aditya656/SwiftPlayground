//
//  ZeptoDeliveryPage.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//



import SwiftUI

struct ZeptoDeliveryPage: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                MapView()
                NotificationCardView()
            }
        }
        .background(Color.gray.opacity(0.4))
        .ignoresSafeArea()
    }
}

#Preview {
    ZeptoDeliveryPage()
}
struct MapView: View {
    @Namespace private var profileAnimation
    @State private var isExpanded: Bool = false
    
    var body: some View {
        ZStack {
            if isExpanded {
                VStack(spacing: 12.0) {
                    Image("img2")
                        .resizable()
                        .matchedGeometryEffect(id: "imageTranslate", in: profileAnimation)
                        .frame(maxWidth: .infinity)
                        .offset(x: 0, y: -600)
//                    Color.clear.frame(height: 50)
                    Text("Suryavanshi vadapav Fastfood & Lunch")
                        .matchedGeometryEffect(id: "subTitleAnimation", in: profileAnimation)
                        .font(.caption)
                        .lineLimit(1)
                    Text("Preparing your order")
                        .matchedGeometryEffect(id: "titleAnimation", in: profileAnimation)
                        .font(.headline)
                        .lineLimit(1)
                    Text("20min • On time")
                        .padding(8)
                        .background(Color.green.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 12.0))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12.0)
                                .stroke(Color.green, lineWidth: 1)
                            
                        }
                    Image("img1")
                        .resizable()
                        .frame(height: 400)
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12.0))
                        .matchedGeometryEffect(id: "profileAnimation", in: profileAnimation)
                        .transition(.offset(y: 1))
                        .onTapGesture {
                            withAnimation(.easeInOut) { isExpanded.toggle() }
                        }
                    
//                    Color.clear
//                        .frame(height: 120)
                }
                .frame(maxWidth: .infinity)
                .background(Color.dynamicBackground)
            } else {
                VStack(spacing: 0) {
                    Image("img2")
                        .resizable()
                        .matchedGeometryEffect(id: "imageTranslate", in: profileAnimation)
                        .frame(maxWidth: .infinity)
                    Color.clear
                        .frame(height: 110)
                }
                .frame(maxWidth: .infinity)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Suryavanshi vadapav Fastfood & Lunch")
                            .matchedGeometryEffect(id: "subTitleAnimation", in: profileAnimation)
                            .font(.caption)
                            .lineLimit(1)
                        Text("Preparing your order")
                            .matchedGeometryEffect(id: "titleAnimation", in: profileAnimation)
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                    Image("img1")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12.0))
                        .matchedGeometryEffect(id: "profileAnimation", in: profileAnimation)
                        .transition(.offset(y: 1))
                        .onTapGesture {
                            withAnimation(.easeInOut) { isExpanded.toggle() }
                        }
                        .padding(8)
                }
                .frame(width: UIScreen.main.bounds.width - 24, height: 136)
                .background(Color.dynamicBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14.0))
                .offset(y: 280)
            }
        }
    }
}

struct NotificationCardView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Suryavanshi vadapav Fastfood & Lunch")
                    .font(.caption)
                    .lineLimit(1)
                Text("Preparing your order")
                    .font(.headline)
                Spacer()
            }
            .padding()
            AsyncImage(url: URL(string: "https://picsum.photos/300")) { downloadedImage in
                downloadedImage
                    .resizable()
                    .frame(width: 120, height: 120)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12.0))
            } placeholder: {
                ProgressView()
            }
            .padding(8)
        }
        .frame(width: UIScreen.main.bounds.width - 24, height: 136)
        .background(Color.dynamicBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14.0))
    }
}
