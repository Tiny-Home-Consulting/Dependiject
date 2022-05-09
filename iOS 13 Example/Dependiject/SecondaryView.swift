//
//  SecondaryView.swift
//  Dependiject_Example
//
//  Created by Wesley Boyd on 05/09/2022.
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

struct SecondaryView_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryView()
    }
}
