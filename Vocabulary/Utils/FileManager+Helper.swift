//
//  FileManager+Helper.swift
//  Vocabulary
//
//  Created by Hardik on 23/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation

final class VFileManager {
    
    static let fileManager = FileManager.default
    
    static func moveAppBundleCSVToDocumentDirectory(sourceFileName: String, destinationFileName: String) {
        DispatchQueue.global().async {
            guard let destinationFileUrl = documentDirectoryFile(withFileName: destinationFileName, fileExtension: "csv"),
                let sourceFileUrl = Bundle.main.url(forResource: sourceFileName, withExtension: "csv") else { return }
            do {
                let fileExists = fileManager.fileExists(atPath: destinationFileUrl.absoluteString)
                if fileExists == false {
                    try fileManager.copyItem(at: sourceFileUrl, to: destinationFileUrl)
                }
            } catch {
                print("Error : \(error)")
            }
        }
    }
    
    static func documentDirectoryFile(withFileName name: String, fileExtension: String) -> URL? {
        guard let documentDirURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let destinationFileUrl = documentDirURL.appendingPathComponent(name + "." + fileExtension)
        return destinationFileUrl
    }
}
