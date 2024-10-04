//
//  SecondaryViewModelTests.swift
//  Dependiject_Tests
//
//  Created by Wesley Boyd on 5/9/22.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import XCTest
import Dependiject
@testable import Dependiject_Example

class SecondaryViewModelTests: XCTestCase {
    var mockDataStateManager: DataStateManagerMock!
    var sut: SecondaryViewModelImplementation!
    
    override func setUp() {
        super.setUp()
        mockDataStateManager = DataStateManagerMock(dataState: .confirmed)
        sut = SecondaryViewModelImplementation(updater: mockDataStateManager)
    }
    
    func testResetData() {
        sut.resetData()
        XCTAssertEqual(mockDataStateManager.calledCount, 1)
        XCTAssertEqual(mockDataStateManager.dataState, .unconfirmed)
    }
}
