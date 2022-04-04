//
//  Resolver.swift
//  swiftdi
//
//  Created by William Baker on 04/04/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

/// A protocol for a container that can provide dependencies, but is not necessarily responsible for
/// registering or creating them.
public protocol Resolver {
    /// Get a dependency of the specified type. Returns the instance if available, or `nil` if no
    /// instance can be provided.
    func getInstance<T>(_ type: T.Type) -> T?
}
