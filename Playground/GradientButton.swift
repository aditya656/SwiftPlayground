//
//  GradientButton.swift
//  Playground
//
//  Created by Aditya Patole on 07/08/25.
//
import UIKit

class GradientButton: UIButton {

    private var tapGesture: UITapGestureRecognizer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        self.backgroundColor = .blue
        self.clipsToBounds = true
        self.layer.cornerRadius = 10

        // Add gesture recognizer
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        showGradient(at: location)
    }

    private func showGradient(at point: CGPoint) {
        let gradientLayer = RadialGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.gradientCenter = point
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.4).cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.startRadius = 0
        gradientLayer.endRadius = 50
        self.layer.addSublayer(gradientLayer)

        // Animate fade out and remove
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            gradientLayer.removeFromSuperlayer()
        }

        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 1
        fade.toValue = 0
        fade.duration = 0.6
        fade.timingFunction = CAMediaTimingFunction(name: .easeOut)
        gradientLayer.add(fade, forKey: "fade")
        gradientLayer.opacity = 0
        CATransaction.commit()
    }
}
