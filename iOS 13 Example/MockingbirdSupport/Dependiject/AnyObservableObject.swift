//
//  Store.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//  MIT License

import Swift
import Combine

public protocol AnyObservableObject: AnyObject {
    var objectWillChange: ObservableObjectPublisher { get }
}
