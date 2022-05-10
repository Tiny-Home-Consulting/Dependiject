//
//  ContentView.swift
//  Dependiject_Example
//
//  Created by William Baker on 04/04/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import SwiftUI
import Dependiject

struct ContentView: View {
    @Store var dataStateAccessor = Factory.shared.resolve(DataStateAccessor.self)
    
    var body: some View {
        switch dataStateAccessor.dataState {
        case .unconfirmed:
            PrimaryView()
        case .confirmed:
            SecondaryView()
        }
    }
}
