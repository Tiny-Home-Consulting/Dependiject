//
//  ContentView.swift
//  swiftdi
//
//  Created by William Baker on 04/04/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import SwiftUI
import swiftdi

struct ContentView: View {
    // Maybe there should be something else that is the same instance as `Factory.shared` but only
    // exposed as type `Resolver`, rather than `Factory`?
    @Store var viewModel = Factory.shared.getInstance(ContentViewModel.self)!
    
    var body: some View {
        VStack(spacing: 0) {
            Button("Fetch new data") {
                viewModel.refreshData()
            }
            .padding()
            
            Divider()
            
            List(viewModel.array, id: \.self) {
                Text("\($0)")
            }
            .listStyle(.grouped)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: ContentViewModelMock()
        )
    }
}
