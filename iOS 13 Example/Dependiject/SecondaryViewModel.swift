//
//  SecondaryViewModel.swift
//  Dependiject_Example
//
//  Created by Wesley Boyd on 05/09/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import Dependiject

protocol SecondaryViewModel {
    /// Go back to PrimaryView to edit data, updates global state
    func resetData()
}

final class SecondaryViewModelImplementation: SecondaryViewModel {
    private let dataStateUpdater: DataStateUpdater
    
    init(updater: DataStateUpdater) {
        self.dataStateUpdater = updater
    }
    
    func resetData() {
        dataStateUpdater.setDataState(confirmed: false)
    }
}
