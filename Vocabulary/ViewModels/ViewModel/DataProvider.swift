//
//  DataProvider.swift
//  Vocabulary
//
//  Created by Hardik on 24/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation

// Confirming Types can provide data as per their requirements whether from file system or Server
protocol DataProvider: class {
    func getLesson(completion: @escaping  (Lesson?, Error?) -> Void)
}
