//
//  LessonViewModelTests.swift
//  VocabularyTests
//
//  Created by Hardik on 24/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation

import XCTest
import Quick
import Nimble

@testable import Vocabulary

class LessonViewModelTests: QuickSpec {
    
    var viewModel: LessonViewModel? = nil
    
    override func spec() {
        
        viewModel = LessonViewModel(with: FileSystemDataProvider())
        guard let vm = viewModel else { return }
        
        describe("ViewModel test") {
            context("Parse csv file") {
                it("should have lesson property set with data") {
                    
                    vm.parseLesson()
                    
                    expect(vm.lesson).toEventuallyNot(beNil())
                    expect(vm.lesson?.questions.count).toEventually(equal(3))
                }
            }
            
            
            context("When moving to next question ") {
                it("should change to next question") {
                    
                    let nextQuestion = vm.lesson?.questions[1]
                    vm.changeToNextQuestion()
                    
                    expect(vm.currentQuestion).toEventuallyNot(beNil())
                    expect(vm.currentQuestion).toEventually(equal(nextQuestion))
                }
            }
        }
    }
}
