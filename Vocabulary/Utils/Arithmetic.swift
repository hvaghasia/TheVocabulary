//
//  Arithmetic.swift
//  Vocabulary
//
//  Created by Hardik on 24/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation

extension Int {
    
    mutating func correctAnswer() {
        switch self {
        case let a where a <= 0: self = 1
        case let a where a >= 4: self = 4
        default: self += 1
        }
    }
    
    mutating func wrongAnswer() {
        switch self {
        case let a where a < 0: self = -1
        default: self -= 1
        }
    }
}
