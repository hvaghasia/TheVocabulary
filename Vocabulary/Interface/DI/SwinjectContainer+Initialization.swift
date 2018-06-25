//
//  SwinjectContainer+Initialization.swift
//  Vocabulary
//
//  Created by Hardik on 23/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

extension Container {
    
    func initiateViewController<T: UIViewController>(storyboardName name: String, type: T.Type) -> T {
        let identifier = String(describing: type)
        return self.initiateViewController(from: name, identifier: identifier)
    }
    
    func initiateViewController<T: UIViewController>(from storyboard: String, identifier: String) -> T {
        let storyboard = SwinjectStoryboard.create(name: storyboard, bundle: nil, container: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
}

enum StoryBoardName {
    case main
    
    var name: String {
        switch self {
        case .main: return "Main"
        }
    }
}
