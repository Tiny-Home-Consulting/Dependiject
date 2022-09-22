//
//  MultitypeServiceTests.swift
//  DependijectTests
//
//  Created by William Baker on 05/17/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import XCTest
@testable import Dependiject

// some types for testing below
fileprivate protocol P1: AnyObject {}
fileprivate protocol P2: AnyObject {}
fileprivate class C: P1, P2 {}

class MultitypeServiceTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
    }
    
    /// Test that the exposed types both resolve the same instance.
    func test_multitypeServiceClosure_typesResolveSame() {
        // set up the dependency container
        Factory.register {
            MultitypeService(exposedAs: [P1.self, P2.self]) { _ in
                C()
            }
        }
        
        // get the instances
        let p1Instance = Factory.shared.resolve(P1.self)
        let p2Instance = Factory.shared.resolve(P2.self)
        
        XCTAssertIdentical(p1Instance, p2Instance, "Both protocols should give the same instance")
    }
    
    /// Test that the original class is hidden by default (i.e. it's registered with an internal
    /// name the caller may not know, rather than being nameless).
    func test_multitypeServiceClosure_hidesOriginal() {
        // Because `resolve()` causes a preconditionFailure when no matches are found, we can't use
        // the factory here. Instead, we have to inspect the `MultitypeService` object itself.
        
        let service = MultitypeService(exposedAs: [P1.self, P2.self]) { _ in
            C()
        }
        
        // Iterating should reveal, in order:
        // { type: P1.self, name: nil }
        // { type: P2.self, name: nil }
        // { type: C.self, name: <some internal name that isn't nil> }
        for registration in service {
            XCTAssertFalse(
                registration.type == C.self && registration.name == nil,
                "Original type should be hidden but was found with no name"
            )
        }
    }
    
    /// Test that the class can be exposed if desired.
    func test_multitypeServiceClosure_allowsResolvingOriginal() {
        // set up the dependency container
        Factory.register {
            MultitypeService(exposedAs: [P1.self, P2.self, C.self]) { _ in
                C()
            }
        }
        
        // check that we can resolve it without crashing
        // if `C.self` were not in the above array, this would crash
        _ = Factory.shared.resolve(C.self)
    }
    
    func test_multitypeServiceConstant_typesResolveSame() {
        // set up the dependency container
        Factory.register {
            MultitypeService(exposedAs: [P1.self, P2.self], C())
        }
        
        // get the instances
        let p1Instance = Factory.shared.resolve(P1.self)
        let p2Instance = Factory.shared.resolve(P2.self)
        
        XCTAssertIdentical(p1Instance, p2Instance, "Both protocols should give the same instance")
    }
    
    func test_multitypeServiceConstant_allowsResolvingOriginal() {
        // set up the dependency container
        Factory.register {
            MultitypeService(exposedAs: [P1.self, P2.self, C.self], C())
        }
        
        // check that we can resolve it without crashing
        // if `C.self` were not in the above array, this would crash
        _ = Factory.shared.resolve(C.self)
    }
    
    func test_multitypeServiceConstant_hidesOriginal() {
        // Because `resolve()` causes a preconditionFailure when no matches are found, we can't use
        // the factory here. Instead, we have to inspect the `MultitypeService` object itself.
        
        let service = MultitypeService(exposedAs: [P1.self, P2.self], C())
        
        // Iterating should reveal, in order:
        // { type: P1.self, name: nil }
        // { type: P2.self, name: nil }
        // { type: C.self, name: <some internal name that isn't nil> }
        for registration in service {
            XCTAssertFalse(
                registration.type == C.self && registration.name == nil,
                "Original type should be hidden but was found with no name"
            )
        }
    }
}
