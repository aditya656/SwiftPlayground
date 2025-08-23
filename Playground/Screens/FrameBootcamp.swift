//
//  FrameBootcamp.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//



import SwiftUI

struct FrameBootcamp: View {
    var body: some View {
        Text("hello there, this is a long line that won't fit parent's size.")
            .border(Color.blue)
            .frame(width: 200, height: 100)
            .border(Color.green)
            .font(.title)
        
        Text("hello there, this is a long line that won't fit parent's size.")
            .fixedSize(horizontal: false, vertical: true)
            .border(Color.blue)
            .frame(width: 200, height: 100)
            .border(Color.green)
            .font(.title)
        
        Text("hello there, this is a long line that won't fit parent's size.")
            .fixedSize(horizontal: true, vertical: false)
            .border(Color.blue)
            .frame(width: 200, height: 100)
            .border(Color.green)
            .font(.title)
    }
}

#Preview {
    FrameBootcamp()
}
