//
//  MathQuizGame.swift
//  Playground
//
//  Created by Aditya Patole on 07/01/26.
//
import SwiftUI

struct MathQuizGame: View {
    @ObservedObject var viewModel = MathQuizViewModel()
    var body: some View {
        divider
        Text(viewModel.questionText)
            .font(.largeTitle)
            .padding(.vertical, 48)
        divider
        
//        Button(viewModel.options.first)
//        RoundedRectangle()
    }
    
    let divider: some View = RoundedRectangle(cornerRadius: 2)
        .fill(Color.gray)
        .frame(width: .infinity, height: 4)
        .padding(.horizontal, 12)
}

#Preview {
    MathQuizGame(viewModel: MathQuizViewModel())
}
