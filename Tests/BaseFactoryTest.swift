//
//  BaseFactoryTest.swift
//  
//
//  Created by William Baker on 10/6/22.
//

import XCTest
@testable import Dependiject

/// The base class for tests that use the factory.
class BaseFactoryTest: XCTestCase {
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
        
        Factory.clearDependencies()
    }
}
