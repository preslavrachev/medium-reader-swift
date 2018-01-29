//
//  ContextITest.swift
//  MediumReader
//
//  Created by Preslav Rachev on 28.07.17.
//  Copyright © 2017 Preslav Rachev. All rights reserved.
//

import XCTest
@testable import MediumReader


class ContextITest: XCTestCase {
    
    
    
    override func setUp() {
        
      
    }
    
    func testDefaultContextCompliance() {
        let context: Context = DefaultContext()
        let mirror = Mirror(reflecting: context)
        
        for prop in mirror.children {
            Swift.print(prop.value)
        }
    }
    
}
