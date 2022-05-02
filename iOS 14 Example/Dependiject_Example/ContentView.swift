//
//  ContentView.swift
//  Dependiject_Example
//
//  Created by William Baker on 04/05/22.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import SwiftUI
import Dependiject

struct ContentView: View {
    @Store var viewModel = Factory.shared.resolve(ContentViewModel.self)
    
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
