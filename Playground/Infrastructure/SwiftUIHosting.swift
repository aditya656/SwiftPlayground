//
//  Hosting.swift
//  Playground
//
//  Created by Aditya Patole on 09/08/25.
//


import SwiftUI
import UIKit

enum Hosting {
    static func make<V: View>(_ view: V) -> UIViewController {
        let hc = UIHostingController(rootView: view)
        hc.view.backgroundColor = .systemBackground
        return hc
    }
}