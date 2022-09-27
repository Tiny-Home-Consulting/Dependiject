//
//  ParallelResolutionTest.swift
//  
//
//  Created by William Baker on 09/27/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import XCTest
@testable import Dependiject

fileprivate class C {}

class ParallelResolutionTest: XCTestCase {
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
    }
    
    func test_parallelResolutions() {
        Factory.register {
            // test both of the stateful registration types
            Service(.singleton, Int.self) { _ in 1 }
            Service(.weak, C.self) { _ in C() }
        }
        
        DispatchQueue.concurrentPerform(iterations: 1000) { _ in
            _ = Factory.shared.resolve(C.self)
            _ = Factory.shared.resolve(Int.self)
        }
    }
}
