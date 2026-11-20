//
//  ContentView.swift
//  Dependiject_Example
//
//  Created by William Baker on 04/05/22.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import SwiftUI
import Dependiject
import Combine

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
