//
//  ScopeTests.swift
//  DependijectTests
//
//  Created by William Baker on 05/17/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import XCTest
@testable import Dependiject

/// A class that counts how many times it was created.
fileprivate class ConstructorCounter {
    static var count = 0
    
    init() {
        Self.count += 1
    }
}

class ScopeTests: XCTestCase {
    /// Reset the counter between tests, and disable continue-on-failure.
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
        ConstructorCounter.count = 0
    }
    
    /// Test that the `singleton` scope only creates one instance.
    func test_singleton_createsOne() {
        // set up the dependency container
        Factory.register {
            Service(.singleton, ConstructorCounter.self) { _ in
                ConstructorCounter()
            }
        }
        
        // grab the instance more than once
        _ = Factory.shared.resolve(ConstructorCounter.self)
        _ = Factory.shared.resolve(ConstructorCounter.self)
        _ = Factory.shared.resolve(ConstructorCounter.self)
        
        // assert that only one was created
        XCTAssertEqual(
            ConstructorCounter.count,
            1,
            "Expected 1 singleton instance but saw \(ConstructorCounter.count)"
        )
    }
    
    /// Test that the `singleton` scope creates its instance lazily.
    func test_singleton_isLazy() {
        // set up the dependency container
        Factory.register {
            Service(.singleton, ConstructorCounter.self) { _ in
                ConstructorCounter()
            }
        }
        
        // don't grab the instance
        
        // assert that the constructor was never called
        XCTAssertEqual(
            ConstructorCounter.count,
            0,
            "Expected no lazy instances but saw \(ConstructorCounter.count)"
        )
    }
    
    /// Test that the `weak` scope only creates a new instance when necessary.
    func test_weak_isWeak() {
        // set up the dependency container
        Factory.register {
            Service(.weak, ConstructorCounter.self) { _ in
                ConstructorCounter()
            }
        }
        
        // grab and hold onto the instance
        var instance: ConstructorCounter? = Factory.shared.resolve(ConstructorCounter.self)
        
        // grab a second instance and make sure it's the same as the first
        var instance2: ConstructorCounter? = Factory.shared.resolve(ConstructorCounter.self)
        
        // XCTAssertEqual uses the `==` function. XCTAssertIdentical checks that they're the same
        // instance.
        XCTAssertIdentical(instance, instance2, "Expected weak variables to be identical")
        
        XCTAssertEqual(
            ConstructorCounter.count,
            1,
            "Expected 1 instance but saw \(ConstructorCounter.count)"
        )
        
        // discard the first instance and create a new one
        instance = nil
        instance2 = nil
        
        _ = Factory.shared.resolve(ConstructorCounter.self)
        
        // check that that created a second instance
        XCTAssertEqual(
            ConstructorCounter.count,
            2,
            "Expected 1 new weak instance but saw \(ConstructorCounter.count - 1)"
        )
    }
    
    /// Test that the `transient` scope creates a new one every time.
    func test_transient_alwaysCreatesNew() {
        // set up the dependency container
        Factory.register {
            Service(.transient, ConstructorCounter.self) { _ in
                ConstructorCounter()
            }
        }
        
        // Call it a few times, checking the constructor count
        XCTAssertEqual(
            ConstructorCounter.count,
            0,
            "Expected no instances yet but saw \(ConstructorCounter.count)"
        )
        
        _ = Factory.shared.resolve(ConstructorCounter.self)
        XCTAssertEqual(
            ConstructorCounter.count,
            1,
            "Expected 1 transient instance but saw \(ConstructorCounter.count)"
        )
        
        _ = Factory.shared.resolve(ConstructorCounter.self)
        _ = Factory.shared.resolve(ConstructorCounter.self)
        XCTAssertEqual(
            ConstructorCounter.count,
            3,
            "Expected 3 transient instances but saw \(ConstructorCounter.count)"
        )
    }
    
    /// Test that the `transient` scope allows value types. `weak` doesn't, but this is enforced by
    /// an `assert` call and cannot be tested.
    func test_transient_allowsStructs() {
        // set up the dependency container
        Factory.register {
            Service(.transient, Int.self) { _ in 1 }
        }
        
        // check that it can be retrieved
        _ = Factory.shared.resolve(Int.self)
    }
    
    /// Test that `Service(constant:_:_:)` grabs the object eagerly but only once.
    func test_constant_isEager() {
        // set up the dependency container
        Factory.register {
            Service(constant: ConstructorCounter(), ConstructorCounter.self)
        }
        
        // Syntactically, that looks like it already called the init, but that's not necessarily
        // given (e.g. `@autoclosure`).
        XCTAssertEqual(
            ConstructorCounter.count,
            1,
            "Expected 1 constant instance but found \(ConstructorCounter.count)"
        )
        
        // grab the instance more than once
        _ = Factory.shared.resolve(ConstructorCounter.self)
        _ = Factory.shared.resolve(ConstructorCounter.self)
        _ = Factory.shared.resolve(ConstructorCounter.self)
        
        // assert that only one was created
        XCTAssertEqual(
            ConstructorCounter.count,
            1,
            "Expected 1 constant instance but saw \(ConstructorCounter.count)"
        )
    }
    
    /// Test that `Service(constant:_:_:)` allows value types.
    func test_constant_allowsStructs() {
        // set up the dependency container
        Factory.register {
            Service(constant: 1, Int.self)
        }
        
        // check that it can be retrieved
        _ = Factory.shared.resolve(Int.self)
    }
}
