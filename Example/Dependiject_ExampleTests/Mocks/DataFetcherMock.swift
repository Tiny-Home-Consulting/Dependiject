//
//  DataFetcherMock.swift
//  Dependiject_Tests
//
//  Created by Riley Baker on 10/3/24.
//

@testable import Dependiject_Example

@MainActor
final class DataFetcherMock: DataFetcher {
    init(data: [Int]) {
        self.data = data
    }
    
    let data: [Int]
    var calledCount = 0
    func getData() -> [Int] {
        calledCount += 1
        return data
    }
}
