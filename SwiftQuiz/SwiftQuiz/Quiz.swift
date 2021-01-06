//
//  Quiz.swift
//  SwiftQuiz
//
//  Created by Erik Vitelli on 22/04/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import Foundation

class Quiz {
    let question: String
    let options: [String]
    private let correctedAnswer: String
    
    init(question: String, options: [String], correctedAnswer: String) {
        self.question = question
        self.options = options
        self.correctedAnswer = correctedAnswer
    }
    
    func validateOption(_ index:Int)-> Bool{
        let answer = options[index]
        return answer == self.correctedAnswer
    }
}
