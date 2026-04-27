//
//  MathQuizViewModel.swift
//  Playground
//
//  Created by Aditya Patole on 07/01/26.
//
import SwiftUI

class MathQuizViewModel: ObservableObject {
    @Published var questionText: String = ""
    var answer = 0
    @Published var redAnswer = -1
    @Published var blueAnswer = -1
    
    var redOptions: [String] = []
    var blueOptions: [String] = []

    // increase difficulty later or set a input for difficulty slider
    
    let operations: [String: (Int, Int) -> Int] = [
        " + ": (+),
        " - ": (-),
        " * ": (*)
    ]
    init() {
        self.questionText = self.getRandomQuestion(digits: 1)
        
    }
    
    private func getRandomQuestion(digits: Int = 1) -> String {
        guard digits > 0 else { return "" }
        let lowerLimit = Int(pow(10.0, Double(digits-1)))
        let upperLimit = Int(pow(10.0, Double(digits)))
        let int1 = Int.random(in: lowerLimit..<upperLimit)
        let int2 = Int.random(in: lowerLimit..<upperLimit)
        
        guard let randomOperation = operations.randomElement() else { return "" }
        answer = randomOperation.value(int1, int2)
//        redOptions = answer.
        return String(int1) + randomOperation.key + String(int2)
    }
}

extension Int {
    func addError() {
        
    }
}
