//
//  DataStateManagerMock.swift
//  Dependiject_Tests
//
//  Created by Riley Baker on 10/3/24.
//

@testable import Dependiject_Example
import Combine

final class DataStateManagerMock: DataStateManager {
    init(dataState: DataState) {
        self.dataState = dataState
    }
    
    var dataState: DataState
    var calledCount = 0
    func setDataState(confirmed: Bool) {
        calledCount += 1
        if confirmed {
            dataState = .confirmed
        } else {
            dataState = .unconfirmed
        }
    }
    
    let objectWillChange = ObservableObjectPublisher()
}
