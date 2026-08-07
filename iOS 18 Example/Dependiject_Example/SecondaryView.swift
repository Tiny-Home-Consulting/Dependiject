//
//  SecondaryView.swift
//  Dependiject_Example
//
//  Created by Wesley Boyd on 5/9/22.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import SwiftUI
import Dependiject

struct SecondaryView: View {
    var viewModel = Factory.shared.resolve(SecondaryViewModel.self)
    
    var body: some View {
        VStack(spacing: 0) {
            Button("Reset Data") {
                viewModel.resetData()
            }
        }
    }
}

#Preview {
    SecondaryView()
}
