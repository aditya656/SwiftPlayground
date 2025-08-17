//
//  Screen.swift
//  Playground
//
//  Created by Aditya Patole on 09/08/25.
//


// Infrastructure/ScreenRegistry.swift

import UIKit
import SwiftUI

protocol Screen {
    var id: String { get }
    var title: String { get }
    func makeViewController() -> UIViewController
}

struct SwiftUIScreen<V: View>: Screen {
    let id: String
    let title: String
    let builder: () -> V
    func makeViewController() -> UIViewController {
        Hosting.make(builder())
    }
}

struct UIKitScreen: Screen {
    let id: String
    let title: String
    let builder: () -> UIViewController
    func makeViewController() -> UIViewController { builder() }
}

final class ScreenRegistry {
    static let shared = ScreenRegistry()
    private(set) var screens: [Screen] = []

    func register(_ screen: Screen) {
        screens.append(screen)
    }

    func screen(with id: String) -> Screen? {
        screens.first { $0.id == id }
    }
}
