//
//  LessonParser.swift
//  Vocabulary
//
//  Created by Hardik on 23/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation

final class CSVFile {
    
    let fileURL: URL
    
    public init?(fileURL: URL) {
        self.fileURL = fileURL
    }
}

extension CSVFile {
    
    static func parseCSVFile<T: JsonDecodable>(fileURL: URL, completion: @escaping (T?, Error?) -> Void) {
        guard let parser = CSVFile(fileURL: fileURL) else { return }
        
        parser.read { data, error in
            if let fileData = data {
                // Parse string data into model object
                parser.parse(data: fileData)  { lesson in
                    // Send parsed data to subscriber
                    completion(lesson, nil)
                }
                return
            }
            // Send error to subscriber
            completion(nil, error)
        }
    }
    
    func read(completion: @escaping (String?, Error?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            do {
                var contents = try String(contentsOf: strongSelf.fileURL, encoding: .utf8)
                contents = strongSelf.cleanRows(file: contents)
                completion(contents, nil)
            } catch {
                print("File Read error: \(strongSelf.fileURL)")
                completion(nil, CSVFileErrors.readFailed)
            }
        }
    }
    
    func cleanRows(file: String) -> String {
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    
    func parse<T: JsonDecodable>(data: String, completion: (T?) -> Void) {
        T.parseCSVFile(for: data) { decodedObject in
            completion(decodedObject)
        }
    }

    static func updateLessonFile(at fileURL: URL, for results: [String]) {
        guard let parser = CSVFile(fileURL: fileURL) else { return }
        DispatchQueue.global().async {

            parser.read { (data, error) in
                
                if let oldData = data {
                    let rows = oldData.components(separatedBy: "\n")
                    var newRows = [String]()
                    newRows.append(rows.first ?? "")
                    for (i, row) in rows.dropFirst().enumerated() where !row.isEmpty {
                        var columns = row.components(separatedBy: ";")
                        if columns.count < 3 { continue }
                        columns[2] = results[i]
                        let newRow = columns.joined(separator: ";")
                        newRows.append(newRow)
                    }
                    
                    let updatedString = newRows.joined(separator: "\n")
                    do {
                        try updatedString.write(to: parser.fileURL, atomically: false, encoding: .utf8)

                    } catch {
                        print("Update error : \(error.localizedDescription)")
                    }
                    
                    return
                }
                
                //TODO: Handle Error
                print("CSV file read error : \(error?.localizedDescription)")
            }
        }
    }
}

extension CSVFile {
    enum CSVFileErrors: Error {
        case pathNotFound
        case readFailed
        case writeFailed
    }
}
