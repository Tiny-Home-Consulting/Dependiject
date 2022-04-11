//
//  swiftdi_ExampleApp.swift
//  swiftdi_Example
//
//  Created by William Baker on 04/05/22.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import SwiftUI
import swiftdi

@main
struct swiftdi_ExampleApp: App {
    init() {
        Factory.register {
            Service(.transient, DataFetcher.self) { _ in
                DataFetcherImplementation()
            }
            
            Service(.transient, DataValidator.self) { _ in
                DataValidatorImplementation()
            }
            
            Service(.weak, ContentViewModel.self) { r in
                ContentViewModelImplementation(
                    fetcher: r.getInstance()!,
                    validator: r.getInstance()!
                )
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
