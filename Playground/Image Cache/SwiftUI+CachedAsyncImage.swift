//
//  CachedAsyncImage.swift
//  Playground
//
//  Created by Aditya Patole on 19/04/26.
//


import SwiftUI

struct CachedAsyncImage: View {

    let urlString: String
    var placeholder: Image = Image(systemName: "photo")

    @StateObject private var loader = ImageLoader()

    var body: some View {
        Group {
            if let uiImage = loader.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else if loader.isLoading {
                ProgressView()
            } else {
                placeholder
                    .foregroundStyle(.secondary)
            }
        }
        .onAppear { loader.load(from: urlString) }
        .onDisappear { loader.cancel() }
    }
}
/*
 Usage:
 
 CachedAsyncImage(urlString: "https://example.com/photo.jpg")
     .frame(width: 120, height: 120)
     .clipShape(RoundedRectangle(cornerRadius: 12))
 
 */
