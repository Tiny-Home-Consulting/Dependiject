//
//  PrimaryViewModel.swift
//  Dependiject_Example
//
//  Created by William Baker on 04/11/22.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import Dependiject

protocol PrimaryViewModel: AnyObservableObject {
    /// A list of things to display.
    var array: [Int] { get }
    /// Update the array.
    func refreshData() async
    /// Confirms data, updates global state
    func confirmData()
}

final class PrimaryViewModelImplementation: PrimaryViewModel, ObservableObject {
    @Published var array: [Int] = []
    
    private let fetcher: DataFetcher
    private let validator: DataValidator
    private let dataStateUpdater: DataStateUpdater
    
    init(
        fetcher: DataFetcher,
        validator: DataValidator,
        updater: DataStateUpdater
    ) {
        self.fetcher = fetcher
        self.validator = validator
        self.dataStateUpdater = updater
    }
    
    func refreshData() async {
        let rawData = await fetcher.getData()
        let filteredData = validator.pickValidItems(from: rawData)
        self.array = filteredData
    }
    
    func confirmData() {
        dataStateUpdater.setDataState(confirmed: true)
    }
}
