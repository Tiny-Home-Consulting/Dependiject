//
//  ConcurrencyTest.swift
//  
//
//  Created by William Baker on 09/23/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import XCTest
@testable import Dependiject

fileprivate final class C: Sendable {}

class ConcurrencyTest: XCTestCase {
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
    }
    
    func test_concurrentResolutions() async {
        // set up the DI container
        Factory.register {
            Service(.weak, C.self) { _ in C() }
            Service(.singleton, Int.self) { _ in 1 }
        }
        
        // create a bunch of concurrently-executing tasks that all try to resolve the same thing
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<1000 {
                group.addTask {
                    _ = await Factory.shared.resolve(C.self)
                    _ = await Factory.shared.resolve(Int.self)
                }
            }
            
            await group.waitForAll()
        }
    }
}
