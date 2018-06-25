//
//  UIDevice+Helper.swift
//  Vocabulary
//
//  Created by Hardik on 24/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation
import AudioToolbox
import UIKit

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
