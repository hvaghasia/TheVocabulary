//
//  SummaryViewModelTests.swift
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

class SummaryViewModelTests: QuickSpec {
    
    var viewModel: SummaryViewModel? = nil
    
    override func spec() {
        
        viewModel = SummaryViewModel(with: StubFileSystemDataProvider())
        guard let vm = viewModel else { return }
        
        describe("ViewModel test") {
            context("test if lesson is finished") {
                it("should have count 4 for all questions") {
                    
                    vm.dataProvider.getLesson { lesson, error in
                        vm.lesson = lesson
                    }
                    
                    expect(vm.lesson).toEventuallyNot(beNil(), timeout: 3)
                    expect(vm.lesson?.questions.count).toEventually(equal(3))
                    
                    expect(vm.lesson?.questions[0].result).toEventually(equal(4))
                    expect(vm.lesson?.questions[1].result).toEventually(equal(4))
                    expect(vm.lesson?.questions[2].result).toEventually(equal(4))
                    
                    // Should be true when result is 4 for all questions
                    expect(vm.isLessonCompleted).toEventually(equal(true))
                }
            }
        }
    }
}


final class StubFileSystemDataProvider: DataProvider {
    
    func getLesson(completion: @escaping (Lesson?, Error?) -> Void) {
        guard let fileUrl = self.filePath else { return }
        CSVFile.parseCSVFile(fileURL: fileUrl) { (lesson: Lesson?, error: Error?) in
            DispatchQueue.main.async {
                completion(lesson, error)
            }
        }
    }
}

extension StubFileSystemDataProvider: SourceFileProvider {
    var fileName: String { return "lesson" }
    
    var filePath: URL? {
        let testBundle = Bundle(for: type(of: self))
        return testBundle.url(forResource: fileName, withExtension: "csv")
    }
}
