//
//  AppState.swift
//  MediumReader
//
//  Created by Preslav Rachev on 28.07.17.
//  Copyright © 2017 Preslav Rachev. All rights reserved.
//

import Foundation

enum PostListViewSelectedState {
    case top
    case tag(String)
}

class AppState {
    var postListViewSelectedState = PostListViewSelectedState.top
    let tags: Array<String> = ["Swift", "Kotlin", "Bitcoin", "Ethereum"]
}
