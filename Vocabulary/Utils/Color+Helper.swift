//
//  Color+Helper.swift
//  Vocabulary
//
//  Created by Hardik on 23/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var rgbInt: UInt64 = 0
        let newHex = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: newHex)
        scanner.scanHexInt64(&rgbInt)
        let r: CGFloat = CGFloat((rgbInt & 0xFF0000) >> 16)/255.0
        let g: CGFloat = CGFloat((rgbInt & 0x00FF00) >> 8)/255.0
        let b: CGFloat = CGFloat(rgbInt & 0x0000FF)/255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
