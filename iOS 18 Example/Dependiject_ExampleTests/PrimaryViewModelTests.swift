//
//  Tests.swift
//  Dependiject_Tests
//
//  Created by William Baker on 04/05/22.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import XCTest
import Dependiject
@testable import Dependiject_Example

@MainActor
final class PrimaryViewModelTests: XCTestCase, Sendable {
    var mockFetcher: DataFetcherMock!
    var mockValidator: DataValidatorMock!
    var mockDataStateManager: DataStateManagerMock!
    var sut: PrimaryViewModelImplementation!
    
    // Even though there's no apparent `await` here, only the async-throws version can access
    // @MainActor data.
    override func setUp() async throws {
        try await super.setUp()
        
        mockDataStateManager = DataStateManagerMock(dataState: .unconfirmed)
        mockFetcher = DataFetcherMock(data: [1, 2, 3, 4, 5, 6])
        mockValidator = DataValidatorMock()
        
        /*
         * In this example case, I'll admit that using the factory here isn't entirely necessary,
         * since the SUT takes its dependencies as arguments to the initializer. However, that isn't
         * necessarily the case -- for example, the view grabs its own view model from the factory
         * -- so I'm using the factory here to demonstrate that it is possible.
         */
        
        Factory.clearDependencies()
        Factory.register {
            Service(constant: self.mockFetcher, DataFetcher.self)
            
            Service(constant: self.mockValidator, DataValidator.self)
            
            MultitypeService(
                exposedAs: [DataStateAccessor.self, DataStateUpdater.self],
                self.mockDataStateManager
            )
        }
        
        sut = PrimaryViewModelImplementation(
            fetcher: Factory.shared.resolve(),
            validator: Factory.shared.resolve(),
            updater: Factory.shared.resolve()
        )
    }
    
    func testExample() async {
        await sut.refreshData()
        
        XCTAssertEqual(mockValidator.calledCount, 1)
        XCTAssertEqual(mockFetcher.calledCount, 1)
        XCTAssertEqual(sut.array, [1, 2, 3, 4, 5, 6])
    }
    
    func testConfirmData() async {
        await sut.refreshData()
        
        sut.confirmData()
        
        XCTAssertEqual(mockDataStateManager.calledCount, 1)
        XCTAssertEqual(mockDataStateManager.dataState, .confirmed)
    }
}
