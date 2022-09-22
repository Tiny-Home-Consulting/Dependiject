//
//  DuplicateRegistrationTest.swift
//  DependijectTests
//
//  Created by William Baker on 05/17/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import XCTest
@testable import Dependiject

class DuplicateRegistrationTest: XCTestCase {
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
    }
    
    /// Test that later registrations override earlier ones when they conflict.
    func test_duplicateRegistration_laterOverridesEarlier() {
        // set up the dependency container more than once
        Factory.register {
            Service(constant: "earlier", String.self)
        }
        
        Factory.register {
            Service(constant: 1, Int.self)
            Service(constant: 2, Int.self)
        }
        
        Factory.register {
            Service(constant: "later", String.self)
        }
        
        // check that only the latter of each type is retrievable
        XCTAssertEqual(
            "later",
            Factory.shared.resolve(),
            "Expected later registration to override earlier one"
        )
        
        XCTAssertEqual(
            2,
            Factory.shared.resolve(),
            "Expected later registration to override earlier one"
        )
    }
}
