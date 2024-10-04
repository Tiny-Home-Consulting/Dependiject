//
//  DataValidatorMock.swift
//  Dependiject_Tests
//
//  Created by Riley Baker on 10/3/24.
//

@testable import Dependiject_Example

final class DataValidatorMock: DataValidator {
    var calledCount = 0
    func pickValidItems(from array: [Int]) -> [Int] {
        calledCount += 1
        return array
    }
}
