//
//  SummaryViewModel.swift
//  Vocabulary
//
//  Created by Hardik on 23/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation
import UIKit

final class SummaryViewModel: NSObject {
    
    // Private set properties
    private(set) var correctAnswerLabelString: NSAttributedString = NSAttributedString(string: "")
    private(set) var wrongAnswerLabelString: NSAttributedString = NSAttributedString(string: "")
    
    // Public stored properties
    @objc dynamic var shouldUpdateView = false
    var headerLabelString = ""
    var lesson: Lesson?
    
    // Public computed properties
    var isLessonCompleted: Bool {
        guard let currentLesson = self.lesson else { return false }
        let currentQuestions = currentLesson.questions
        return (currentQuestions.filter { $0.result == 4 }).count == currentQuestions.count
    }
    
    // DI
    let dataProvider: DataProvider
    
    // Init
    init(with dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        super.init()
    }
    
    func parseLesson() {
        dataProvider.getLesson { [weak self] oldLesson, error in
            guard let strongSelf = self else { return }

            if let err = error {
                //TODO: Handle Error
                return
            }
            
            if let currentLesson = strongSelf.lesson {
                let currentQuestions = currentLesson.questions
                if strongSelf.isLessonCompleted {
                    strongSelf.headerLabelString = "summary.header.lesson.completed".localized
                } else if let oldLesson = oldLesson {
                    let oldQuestions = oldLesson.questions
                    var correctAnswers = 0
                    var wrongAnswers = 0
                    for (old, new) in zip(oldQuestions, currentQuestions) {
                        let isCorrect = new.result - old.result > 0
                        correctAnswers += isCorrect ? 1 : 0
                        wrongAnswers += !isCorrect ? 1 : 0
                    }
                    
                    let correctLabelString = "summary.result.correct.answers-count".localized
                    let correctLabelCompleteString = correctLabelString + "\(correctAnswers)"
                    strongSelf.correctAnswerLabelString = strongSelf.resultAttributedString(completeString: correctLabelCompleteString, boldString: "\(correctAnswers)")
                    
                    let wrongAnswerLabelString = "summary.result.wrong.answers-count".localized
                    let wrongAnswerLabelCompleteString = wrongAnswerLabelString + "\(wrongAnswers)"
                    strongSelf.wrongAnswerLabelString = strongSelf.resultAttributedString(completeString: wrongAnswerLabelCompleteString, boldString: "\(wrongAnswers)")

                    strongSelf.headerLabelString = "summary.header.lesson.attempt.finished".localized
                }
                
                strongSelf.shouldUpdateView = true
            }
        }
    }
    
    private func resultAttributedString(completeString: String, boldString: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: completeString)
        attributedString.addAttribute(NSAttributedStringKey.font, value: AppTheme.summaryResultLabelNormalFont, range: (completeString as NSString).range(of: boldString))
        attributedString.addAttribute(NSAttributedStringKey.font, value: AppTheme.summaryResultLabelBoldFont, range: (completeString as NSString).range(of: "\(boldString)"))
        return attributedString
    }
    
    // Save user answers results into file system back
    func writeLessonDataToFile() {
        guard let lesson = self.lesson else { return }
        guard let url = (self.dataProvider as! FileSystemDataProvider).filePath else { return }
        let results = lesson.questions.map { "\($0.result)" }
        
        CSVFile.updateLessonFile(at: url, for: results)
    }
}
