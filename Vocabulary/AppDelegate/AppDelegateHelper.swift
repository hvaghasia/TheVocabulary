//
//  AppDelegateHelper.swift
//  Vocabulary
//
//  Created by Hardik on 23/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//
import Foundation
import Swinject
import UIKit

extension AppDelegate {
    
    func configureServices() {
        self.assembler = Assembler([ViewModelsAssembly()])
        
        self.viewControllersContainer = ViewControllersContainer(assembler: self.assembler)
        self.viewControllersContainer.registerViewControllers()
        self.container = self.viewControllersContainer.container
    }
    
    func setupInitialViewController() {
        VFileManager.moveAppBundleCSVToDocumentDirectory(sourceFileName: "lesson", destinationFileName: "lesson")
        
        let lessonViewController = self.container.initiateViewController(storyboardName: "Main",
                                                                        type: LessonViewController.self)
        self.window?.rootViewController = lessonViewController
    }
}


extension UIApplication {
    
    static var mainAssembler: Assembler {
        return (self.shared.delegate as? AppDelegate)!.assembler
    }
    
    static var mainContainer: Container {
        return (self.shared.delegate as? AppDelegate)!.container
    }
}
