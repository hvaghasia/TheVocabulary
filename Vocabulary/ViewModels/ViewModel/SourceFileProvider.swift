//
//  SourceFileProvider.swift
//  Vocabulary
//
//  Created by Hardik on 24/06/18.
//  Copyright © 2018 Avira. All rights reserved.
//

import Foundation

protocol SourceFileProvider {
    var fileName: String { get }
    var filePath: URL? { get }
}
