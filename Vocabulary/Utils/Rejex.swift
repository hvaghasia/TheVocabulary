//
//  Rejex.swift
//  Vocabulary
//
//  Created by Hardik on 24/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation

struct Regex {
    
    var internalExpression: NSRegularExpression?
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        do {
            self.internalExpression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        } catch {}
    }
    
    
    func matches(_ input: String) -> [String] {
        if let matches = self.internalExpression?.matches(in: input,
                                                          options: .reportCompletion,
                                                          range: NSMakeRange(0, input.count)) {
            
            return matches.map { (input as NSString).substring(with: $0.range) }
        }
        return []
    }
    
    func match(_ input: String) -> Bool {
        return self.matches(input).count > 0
    }
}

// Declare a easy operator to use
infix operator <>

func <>(input: String, regex: String) -> [String] {
    return Regex(regex).matches(input)
}
