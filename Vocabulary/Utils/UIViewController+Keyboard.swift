//
//  UIViewController+Keyboard.swift
//  Vocabulary
//
//  Created by Hardik on 24/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation
import UIKit

extension Notification {
    var keyboardSize: CGSize { return (self.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size }
}

extension UIViewController {
    
    typealias KeyboardDispatcher = (_ keyboardSize: CGSize) -> (Void)
    
    func startObservingKeyboard(viewShow willShowActioner: @escaping KeyboardDispatcher,
                                viewHide willHideActioner: @escaping KeyboardDispatcher) {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { [weak self] notification in
            willShowActioner(notification.keyboardSize)
            self?.view.layoutIfNeeded()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { [weak self] notification in
            willHideActioner(notification.keyboardSize)
            self?.view.layoutIfNeeded()
        }
    }
    
    func stopKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
}
