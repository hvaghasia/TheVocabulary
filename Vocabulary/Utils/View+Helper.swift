//
//  View+Helper.swift
//  Vocabulary
//
//  Created by Hardik on 23/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func roundedCorners() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.height / 2.0
    }
    
    func addRoundedCorners(withRadius radius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func addBorder(withBorderWidth width: CGFloat, color: UIColor, radius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
        self.addBorder(withBorderWidth: width, color: color)
    }
    
    func addBorder(withBorderWidth width: CGFloat, color: UIColor) {
        self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}

public enum LinePosition: Int {
    case bottom = 0
    case top = 1
    case left = 2
    case right = 3
}

public extension UIView {
    
    func drawLine(_ position: LinePosition, color: UIColor = .lightGray) -> Void {
        
        let layer = CALayer()
        layer.borderColor = color.cgColor
        layer.borderWidth = 1.0
        
        switch position {
        case .bottom:
            layer.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1)
            break
        case .top:
            layer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1)
            break
        case .left:
            layer.frame = CGRect(x: 0, y: 0, width: 1, height: self.frame.height)
            break
        case .right:
            layer.frame = CGRect(x: 0, y: self.frame.width - 1, width: 1, height: self.frame.height)
            break
        }
        
        self.layer.masksToBounds = true
        self.layer.addSublayer(layer)
    }
    
    func round(corners: UIRectCorner = .allCorners, withRadius radius: CGFloat = 5.0) {
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii:CGSize(width: radius, height:radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
    }
    
}



extension UIButton {
    
    func roundCorners() {
        self.addRoundedCorners(withRadius: 8.0)
    }
}

extension UIView {
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.5
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
