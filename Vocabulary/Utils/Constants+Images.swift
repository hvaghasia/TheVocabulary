//
//  Constants+Images.swift
//  Vocabulary
//
//  Created by Hardik on 24/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import UIKit

enum Asset: String {
    case correctAnswer = "answer_correct"
    case wrongAnswer = "answer_incorrect"
    
    var image: UIImage {
        return UIImage(asset: self)
    }
}
