//
//  Context.swift
//  MediumReader
//
//  Created by Preslav Rachev on 19.07.17.
//  Copyright © 2017 Preslav Rachev. All rights reserved.
//

import Foundation

protocol ContextProvider {
    var context: Context {get}
}

protocol Context {
    var mediumApiManager: MediumApiManager {get}
}

class DefaultContext: Context {
    static let sharedInstance = DefaultContext()
    
    lazy var mediumApiManager: MediumApiManager = DefaultMediumApiManager();
}
