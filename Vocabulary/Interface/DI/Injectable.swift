//
//  Injectable.swift
//  Vocabulary
//
//  Created by Hardik on 23/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import UIKit

class InjectableViewController: UIViewController {
    
    internal var assembler = UIApplication.mainAssembler
    internal var container: Container!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
}

extension InjectableViewController {
    
    fileprivate func setup() {
        self.container = Container(parent: UIApplication.mainContainer)
    }
}
