//
//  String+Helper.swift
//  Vocabulary
//
//  Created by Hardik on 24/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation

public extension String {
    
    public var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: Bundle.main, value: "", comment: "")
    }
    
    public func localized(_ arguments: [CVarArg], tableName: String? = "Localizable") -> String {
        let localizedStr = NSLocalizedString(self, tableName: tableName, bundle: Bundle.main, value: "", comment: "")
        
        let variables = localizedStr <> "%(\\d\\$)?@"
        
        guard variables.count <= arguments.count else { return self }
        
        return String(format: localizedStr, arguments: arguments)
    }
}
