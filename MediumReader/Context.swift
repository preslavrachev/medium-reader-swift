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
    var appState: AppState {get}
    var mediumApiManager: MediumApiManager {get}
}

class DefaultContext: Context {
    lazy var appState: AppState = AppState();
    lazy var mediumApiManager: MediumApiManager = DefaultMediumApiManager();
}
