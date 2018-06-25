//
//  UIImage+Helper.swift
//  Vocabulary
//
//  Created by Hardik on 24/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import UIKit

extension UIImage {
    
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}

