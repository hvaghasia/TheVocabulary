//
//  ViewModelAssembler.swift
//  Vocabulary
//
//  Created by Hardik on 23/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation
import Swinject

open class ViewModelsAssembly: Assembly {
    
    public init() {}
    
    open func assemble(container: Container) {
        container.register(LessonViewModel.self) { r in
            return LessonViewModel(with: r.resolve(FileSystemDataProvider.self)!)
        }
        
        container.register(SummaryViewModel.self) { r in
            return SummaryViewModel(with: r.resolve(FileSystemDataProvider.self)!)
        }
        
        container.register(FileSystemDataProvider.self) { r in
            return FileSystemDataProvider()
        }
    }
}
