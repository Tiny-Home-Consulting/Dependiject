//
//  Dependiject_ExampleApp.swift
//  Dependiject_Example
//
//  Created by William Baker on 04/05/22.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import SwiftUI
import Dependiject

@main
struct Dependiject_ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        Factory.register {
            Service(.transient, DataFetcher.self) { _ in
                DataFetcherImplementation()
            }
            
            Service(.transient, DataValidator.self) { _ in
                DataValidatorImplementation()
            }
            
            MultitypeService(exposedAs: [DataStateUpdater.self, DataStateAccessor.self]) { r in
                DataStateManagerImplementation()
            }
            
            Service(.weak, PrimaryViewModel.self) { r in
                PrimaryViewModelImplementation(
                    fetcher: r.resolve(),
                    validator: r.resolve(),
                    updater: r.resolve()
                )
            }
            
            Service(.weak, SecondaryViewModel.self) { r in
                SecondaryViewModelImplementation(
                    updater: r.resolve()
                )
            }
        }
    }
}
