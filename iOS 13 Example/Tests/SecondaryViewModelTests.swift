//
//  SecondaryViewModelTests.swift
//  Dependiject_Example
//
//  Created by Wesley Boyd on 05/09/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import XCTest
import Dependiject
import Mockingbird
@testable import Dependiject_Example

class SecondaryViewModelTests: XCTestCase {
    var mockDataStateManager: DataStateManagerMock!
    var sut: SecondaryViewModelImplementation!

    override func setUp() {
        super.setUp()
        mockDataStateManager = mock(DataStateManager.self)
        sut = SecondaryViewModelImplementation(updater: mockDataStateManager)
    }

    func testResetData() {
        sut.resetData()
        verify(mockDataStateManager.setDataState(confirmed: false)).wasCalled(once)
    }
}
