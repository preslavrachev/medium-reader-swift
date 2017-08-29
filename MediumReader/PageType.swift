//
//  PageType.swift
//  MediumReader
//
//  Created by Preslav Rachev on 09.08.17.
//  Copyright © 2017 Preslav Rachev. All rights reserved.
//

import Foundation

enum PageType {
    case top
    case tag(tag:String)
    
    func pageMapping() -> String {
        switch self {
        case .top:
            return "top-stories"
        case let .tag(tag):
            return "tag/\(tag.lowercased())"
        }
    }
    
}
