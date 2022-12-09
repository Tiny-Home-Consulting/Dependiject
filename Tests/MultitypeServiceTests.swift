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

final class MultitypeServiceTests: BaseFactoryTest {
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
    func test_multitypeServiceClosureArray_hidesOriginal() {
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
    
    func test_multitypeServiceClosureDictionary_hidesOriginal() {
        let service = MultitypeService(exposedAs: [P1.self: "a", P2.self: "b"]) { _ in
            C()
        }
        
        // Iterating should reveal, in order:
        // { type: P1.self, name: "a" }
        // { type: P2.self, name: "b" }
        // { type: C.self, name: <some internal name that isn't nil, "a", or "b"> }
        let invalidNames: Set<String?> = ["a", "b", nil]
        for registration in service {
            let name = registration.name
            XCTAssertFalse(
                registration.type == C.self && invalidNames.contains(name),
                "Original type should be hidden but was found with name \(name?.debugDescription ?? "nil")"
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
    
    func test_multitypeServiceConstantArray_hidesOriginal() {
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
    
    func test_multitypeServiceConstantDictionary_hidesOriginal() {
        let service = MultitypeService(exposedAs: [P1.self: "a", P2.self: "b"], C())
        
        // Iterating should reveal, in order:
        // { type: P1.self, name: "a" }
        // { type: P2.self, name: "b" }
        // { type: C.self, name: <some internal name that isn't nil, "a", or "b"> }
        let invalidNames: Set<String?> = ["a", "b", nil]
        for registration in service {
            let name = registration.name
            XCTAssertFalse(
                registration.type == C.self && invalidNames.contains(name),
                "Original type should be hidden but was found with name \(name?.debugDescription ?? "nil")"
            )
        }
    }
    
    func test_multitypeServiceClosure_sharedNameResolves() {
        Factory.register {
            MultitypeService(exposedAs: [P1.self, P2.self], name: "test name") { _ in
                C()
            }
        }
        
        let p1Instance = Factory.shared.resolve(P1.self, name: "test name")
        let p2Instance = Factory.shared.resolve(P2.self, name: "test name")
        
        XCTAssertIdentical(p1Instance, p2Instance, "Both protocols should give the same instance")
    }
    
    func test_multitypeServiceConstant_sharedNameResolves() {
        Factory.register {
            MultitypeService(exposedAs: [P1.self, P2.self], name: "test name", C())
        }
        
        let p1Instance = Factory.shared.resolve(P1.self, name: "test name")
        let p2Instance = Factory.shared.resolve(P2.self, name: "test name")
        
        XCTAssertIdentical(p1Instance, p2Instance, "Both protocols should give the same instance")
    }
    
    func test_multitypeServiceClosure_individualNamesStaySeparate() {
        Factory.register {
            MultitypeService(exposedAs: [
                P1.self: "protocol 1",
                P2.self: "protocol 2",
                C.self: "class"
            ]) { _ in
                C()
            }
        }
        
        _ = Factory.shared.resolve(P1.self, name: "protocol 1")
        _ = Factory.shared.resolve(P2.self, name: "protocol 2")
        _ = Factory.shared.resolve(C.self, name: "class")
    }
    
    func test_multitypeServiceClosureDictionary_originalNamedNilDoesntUseHiddenName() {
        Factory.register {
            MultitypeService(exposedAs: [C.self: nil]) { _ in
                C()
            }
        }
        
        let resolveCount = Factory.shared.resolveAll(C.self).count
        XCTAssertEqual(
            resolveCount, 1,
            "C should have 1 registration but found \(resolveCount)"
        )
    }
    
    func test_multitypeServiceConstant_individualNamesAllowNil() {
        Factory.register {
            MultitypeService( exposedAs: [C.self: nil], C())
        }
        
        let resolveCount = Factory.shared.resolveAll(C.self).count
        XCTAssertEqual(
            resolveCount, 1,
            "C should have 1 registration but found \(resolveCount)"
        )
    }
}
