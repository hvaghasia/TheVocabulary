//
//  LessonViewModel.swift
//  Vocabulary
//
//  Created by Hardik on 23/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation

final class LessonViewModel: NSObject {
    
    // compluted properties
    var lesson: Lesson? {
        didSet {
            formatData()
            questionsDataSource = lesson?.questionsToBeAnswered ?? []
            currentQuestion = questionsDataSource.first
        }
    }
    
    
    // public stored properties
    var questionWordLanguageString = ""
    var answerWordLanguageString = ""
    @objc dynamic var currentQuestion: Question?
    
    // Private stored properties
    private var questionsDataSource = [Question]()
    private var currentQuestionIndex = 0
    private var nextQuestion: Question? {
        currentQuestionIndex += 1
        guard currentQuestionIndex != questionsDataSource.count else { return nil }
        
        return questionsDataSource[currentQuestionIndex]
    }
    
    // DI
    let dataProvider: DataProvider
    
    init(with dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        super.init()
        
        setup()
    }
    
    func parseLesson() {
        dataProvider.getLesson { lesson, error in
            if let err = error {
                //TODO: Handle Error
                return
            }
            self.lesson = lesson
        }
    }
    
    func changeToNextQuestion() {
        currentQuestion = nextQuestion
    }
    
    func resetData() {
        currentQuestionIndex = 0
        currentQuestion = nil
    }
}

// MARK: - Private
extension LessonViewModel {
    
    private func setup() {}

    // Format data to be displyed on Lesson view
    private func formatData() {
        guard let lesson = self.lesson else { return }
        self.questionWordLanguageString = lesson.questionLanguage + ":"
        self.answerWordLanguageString = lesson.answerLanguage + ":"
    }
}
