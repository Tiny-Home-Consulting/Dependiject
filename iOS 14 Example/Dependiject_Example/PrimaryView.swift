//
//  PrimaryView.swift
//  Dependiject_Example
//
//  Created by Wesley Boyd on 05/09/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import SwiftUI
import Dependiject

struct PrimaryView: View {
    @Store var viewModel = Factory.shared.resolve(PrimaryViewModel.self)
    
    var body: some View {
        VStack(spacing: 0) {
            Button("Fetch new data") {
                Task {
                    await viewModel.refreshData()
                }
            }
            .padding()
            
            Divider()
            
            // If there's not enough items to fill the whole area, the background will be colored
            // UIColor.systemGroupedBackground. Starting in iOS 16, however, this does not happen
            // for a list that is completely empty.
            if #available(iOS 16, *),
               viewModel.array.isEmpty {
                Color(UIColor.systemGroupedBackground)
            } else {
                List(viewModel.array, id: \.self) {
                    Text("\($0)")
                }
                .listStyle(.grouped)
            }
            
            Button("Confirm Data") {
                viewModel.confirmData()
            }
            .padding()
        }
    }
}

struct PrimaryView_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryView()
    }
}
