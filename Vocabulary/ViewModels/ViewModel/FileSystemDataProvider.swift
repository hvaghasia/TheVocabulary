//
//  FileSystemDataProvider.swift
//  Vocabulary
//
//  Created by Hardik on 24/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation

// Class which parse data from file system and mapped into Model
final class FileSystemDataProvider: DataProvider {
    
    func getLesson(completion: @escaping (Lesson?, Error?) -> Void) {
        guard let fileUrl = self.filePath else { return }
        CSVFile.parseCSVFile(fileURL: fileUrl) { (lesson: Lesson?, error: Error?) in
            completion(lesson, error)
        }
    }
}

extension FileSystemDataProvider: SourceFileProvider {
    var fileName: String { return "lesson" }
    
    var filePath: URL? {
        return VFileManager.documentDirectoryFile(withFileName: fileName, fileExtension: "csv")
    }
}
