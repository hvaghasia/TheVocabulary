//
//  Question.swift
//  Vocabulary
//
//  Created by Hardik on 23/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation

final class Question: NSObject {
    let questionWord: String
    let answerWord: String
    var result: Int
    
    init(question: String, answer: String, result: Int) {
        self.questionWord = question
        self.answerWord = answer
        self.result = result
    }
}
