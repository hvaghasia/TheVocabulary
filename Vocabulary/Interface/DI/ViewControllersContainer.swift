//
//  ViewControllersContainer.swift
//  Vocabulary
//
//  Created by Hardik on 23/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

final class ViewControllersContainer {
    
    let container: Container
    let assembler: Assembler
    
    init(assembler: Assembler) {
        self.assembler = assembler
        self.container = Container()
    }
    
    func registerViewControllers() {
        self.registerMainControllers()
    }
}


extension ViewControllersContainer {
    
    fileprivate func registerMainControllers() {
        self.container.storyboardInitCompleted(LessonViewController.self) { r, c in
            c.viewModel = self.assembler.resolver.resolve(LessonViewModel.self)
        }
        
        self.container.storyboardInitCompleted(SummaryViewController.self) { r, c in
            c.viewModel = self.assembler.resolver.resolve(SummaryViewModel.self)
        }
    }
}
