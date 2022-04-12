//
//  ContentViewModel.swift
//  swiftdi_Example
//
//  Created by William Baker on 04/11/22.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import Combine

protocol ContentViewModel: AnyObservableObject {
    /// A list of things to display.
    var array: [Int] { get }
    /// Update the array.
    func refreshData()
}

final class ContentViewModelImplementation: ContentViewModel, ObservableObject {
    @Published var array: [Int] = []
    
    private let fetcher: DataFetcher
    private let validator: DataValidator
    
    init(fetcher: DataFetcher, validator: DataValidator) {
        self.fetcher = fetcher
        self.validator = validator
    }
    
    func refreshData() {
        let rawData = fetcher.getData()
        let filteredData = validator.pickValidItems(from: rawData)
        self.array = filteredData
    }
}

final class ContentViewModelMock: ContentViewModel, ObservableObject {
    @Published var array: [Int] = [2, 4, 6, 8]
    
    func refreshData() {
        // no-op
    }
}
