//
//  ParallaxEffectView.swift
//  Playground
//
//  Created by Aditya Patole on 04/12/25.
//

import SwiftUI

struct ParallaxEffectView: View {
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFit()
            Image("border")
                .resizable()
                .scaledToFit()
            Image("coin1")
                .resizable()
                .scaledToFit()
//                .motionEffect(magnitude: 20)
            Image("coin2")
                .resizable()
                .scaledToFit()
//                .motionEffect(magnitude: 10)
            Image("coin3")
                .resizable()
                .scaledToFit()
//                .motionEffect(magnitude: 15)
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}

#Preview {
    ParallaxEffectView()
}
