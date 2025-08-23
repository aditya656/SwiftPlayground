//
//  OpacityTransition.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//

import SwiftUI

struct OpacityTransitionTest: View {
    @State var toggleAnimation: Bool = false
    
    public var body: some View {
        VStack {
            ZStack {
                if toggleAnimation {
                    Rectangle()
                        .frame(width: Constants.Screen.width - 48, height: 100)
                        .background(Color.gray.opacity(0.8))
                } else {
                    Rectangle()
                        .frame(width: Constants.Screen.width - 48, height: 100)
                        .background(Color.red)
                }
            }
                .frame(width: Constants.Screen.width - 24, height: 200)
                .background(Color.white)
            Button(action: {
                toggleAnimation.toggle()
            }, label: {
                Text("Toggle")
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .ignoresSafeArea()
    }
}

#Preview {
    OpacityTransitionTest(toggleAnimation: true)
}
