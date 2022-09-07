//
//  Services.swift
//  Dependiject_Example
//
//  Created by William Baker on 04/11/22.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import Dependiject
import Combine

protocol DataFetcher {
    func getData() async -> [Int]
}

struct DataFetcherImplementation: DataFetcher {
    func getData() async -> [Int] {
        let upperLimit = Int.random(in: 4...20)
        // Not noticeably long, but enough to potentially change threads
        try? await Task.sleep(nanoseconds: 1000)
        return Array(1...upperLimit)
    }
}

protocol DataValidator {
    func pickValidItems(from array: [Int]) -> [Int]
}

struct DataValidatorImplementation: DataValidator {
    func pickValidItems(from array: [Int]) -> [Int] {
        return array.filter {
            $0.isMultiple(of: 2)
        }
    }
}

protocol DataStateUpdater {
    func setDataState(confirmed: Bool)
}

protocol DataStateAccessor: AnyObservableObject {
    var dataState: DataState { get }
}

protocol DataStateManager: DataStateUpdater, DataStateAccessor {}

final class DataStateManagerImplementation: DataStateManager & ObservableObject {
    @Published var dataState: DataState
    
    init() {
        self.dataState = .unconfirmed
    }
    
    func setDataState(confirmed: Bool) {
        if confirmed {
            self.dataState = .confirmed
        } else {
            self.dataState = .unconfirmed
        }
    }
}
