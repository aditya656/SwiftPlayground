//
//  ImageCache.swift
//  Playground
//
//  Created by Aditya Patole on 19/04/26.
//


import UIKit

final class ImageCache {

    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    private init() {
        cache.countLimit = 100        // max 100 images
        cache.totalCostLimit = 50 * 1024 * 1024  // ~50 MB
    }

    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func remove(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    func clear() {
        cache.removeAllObjects()
    }
}