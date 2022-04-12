//
//  Tests.swift
//  Dependiject_Tests
//
//  Created by William Baker on 04/05/22.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import XCTest
import Dependiject
import Mockingbird
@testable import Dependiject_Example

class Tests: XCTestCase {
    var mockFetcher: DataFetcherMock!
    var mockValidator: DataValidatorMock!
    var sut: ContentViewModel!
    
    override func setUp() {
        super.setUp()
        
        mockFetcher = mock(DataFetcher.self)
        given(mockFetcher.getData()).willReturn([1, 2, 3, 4, 5, 6])
        
        mockValidator = mock(DataValidator.self)
        given(mockValidator.pickValidItems(from: any())).will { $0 }
        
        /*
         * In this example case, I'll admit that using the factory here isn't entirely necessary,
         * since the SUT takes its dependencies as arguments to the initializer. However, that isn't
         * necessarily the case -- for example, the view grabs its own view model from the factory
         * -- so I'm using the factory here to demonstrate that it is possible.
         */
        
        Factory.register {
            Service(.transient, DataFetcher.self) { _ in
                self.mockFetcher
            }
            
            Service(.transient, DataValidator.self) { _ in
                self.mockValidator
            }
        }
        
        sut = ContentViewModelImplementation(
            fetcher: Factory.shared.getInstance()!,
            validator: Factory.shared.getInstance()!
        )
    }
    
    func testExample() {
        sut.refreshData()
        
        XCTAssertEqual(sut.array, [1, 2, 3, 4, 5, 6])
        
        verify(mockFetcher.getData()).wasCalled(1)
        verify(mockValidator.pickValidItems(from: any())).wasCalled(1)
    }
}
