//
//  Lesson.swift
//  Vocabulary
//
//  Created by Hardik on 23/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation

protocol JsonDecodable: class {
    init(json: [String: Any])
    static func parseCSVFile<T: JsonDecodable>(for fileData: String, completion: (T?) -> Void)
}

final class Lesson: NSObject, JsonDecodable {
    let questionLanguage: String
    let answerLanguage: String
    
    let questions: [Question]
    
    init(json: [String : Any]) {
        self.questionLanguage = json["questionLanguage"] as? String ?? ""
        self.answerLanguage = json["answerLanguage"] as? String ?? ""
        self.questions = json["questions"] as? [Question] ?? []
    }
    
    static func parseCSVFile<T: JsonDecodable>(for fileData: String, completion: (T?) -> Void) {
        let rows = fileData.components(separatedBy: "\n")
        
        if let firstRow = rows.first {
            
            var lessonJson = [String: Any]()
            let columns = firstRow.components(separatedBy: ";")
            let questionLang = columns[0]
            let answerLang = columns[1]
            
            lessonJson["questionLanguage"] = questionLang
            lessonJson["answerLanguage"] = answerLang
            
            var questions = [Question]()
            for row in rows.dropFirst() where !row.isEmpty {
                let columns = row.components(separatedBy: ";")
                if columns.count < 3 { continue }
                let questionWord = columns[0]
                let answerWord = columns[1]
                let result = Int(columns[2]) ?? 0
                let question = Question(question: questionWord, answer: answerWord, result: result)
                questions.append(question)
            }
            lessonJson["questions"] = questions
            
            let lesson = T(json: lessonJson)
            completion(lesson)
            return
        }
        completion(nil)
    }
}

