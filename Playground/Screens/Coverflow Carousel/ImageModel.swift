//
//  ImageModel.swift
//  Playground
//
//  Created by Aditya Patole on 24/09/25.
//

import SwiftUI
struct ImageModel: Identifiable {
    var id: UUID = .init()
    var image: String
}
var images: [ImageModel] = (1...8).compactMap({ImageModel(image: "Profile \($0)")})
