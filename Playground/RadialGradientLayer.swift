//
//  RadialGradientLayer.swift
//  Playground
//
//  Created by Aditya Patole on 07/08/25.
//
import UIKit

class RadialGradientLayer: CALayer {

    var colors: [CGColor] = [UIColor.white.cgColor, UIColor.clear.cgColor]
    var gradientCenter: CGPoint = .zero
    var startRadius: CGFloat = 0
    var endRadius: CGFloat = 50

    override func draw(in ctx: CGContext) {
        ctx.saveGState()

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations: [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: colorSpace,
                                        colors: colors as CFArray,
                                        locations: locations) else {
            return
        }

        ctx.drawRadialGradient(gradient,
                               startCenter: gradientCenter,
                               startRadius: startRadius,
                               endCenter: gradientCenter,
                               endRadius: endRadius,
                               options: [.drawsAfterEndLocation])
        ctx.restoreGState()
    }
}
