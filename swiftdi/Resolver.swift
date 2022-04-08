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

public extension Resolver {
    /// Get a dependency of the implicit type. Returns the instance if available, or `nil` if no
    /// instance can be provided.
    ///
    /// - Note: If the inferred type is incorrect, or if Swift cannot infer the type, use
    /// ``getInstance(_:)`` instead (which takes the type as a parameter).
    func getInstance<T>() -> T? {
        return self.getInstance(T.self)
    }
}
