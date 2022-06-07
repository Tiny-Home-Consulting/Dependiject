//
//  RegistrationNameTests.swift
//  DependijectTests
//
//  Created by William Baker on 05/17/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import XCTest
@testable import Dependiject

class RegistrationNameTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
    }
    
    /// Test that dependency names are handled correctly.
    func test_names_disambiguate() {
        // set up the dependency container
        Factory.register {
            Service(.transient, String.self, nil) { _ in "unnamed" }
            Service(.transient, String.self, "1") { _ in "named 1" }
            Service(.transient, String.self, "2") { _ in "named 2" }
        }
        
        // ensure the default is unnamed
        let defaultResolution: String = Factory.shared.resolve()
        XCTAssertEqual(
            "unnamed",
            defaultResolution,
            "Expected default to be unnamed but saw registration \(defaultResolution)"
        )
        
        // ensure type specification and name specification don't interfere
        let typedResolution = Factory.shared.resolve(String.self)
        XCTAssertEqual(
            "unnamed",
            typedResolution,
            "Expected nameless to be unnamed but saw registration \(typedResolution)"
        )
        
        // ensure explicit nil works
        let nilResolution: String = Factory.shared.resolve(name: nil)
        XCTAssertEqual(
            "unnamed",
            nilResolution,
            "Expected nil-named to be unnamed but saw registration \(nilResolution)"
        )
        
        // ensure names actually work
        let namedResolution = Factory.shared.resolve(String.self, name: "1")
        XCTAssertEqual(
            "named 1",
            namedResolution,
            "Expected expliticly-named to be named '1' but saw registration \(namedResolution)"
        )
    }
}
