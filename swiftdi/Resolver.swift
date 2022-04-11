//
//  Resolver.swift
//  swiftdi
//
//  Created by William Baker on 04/04/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

/// A container that can provide dependencies, but is not necessarily responsible for registering or
/// creating them.
public protocol Resolver {
    /// Get a dependency of the specified type, using the name for disambiguation. Returns the
    /// instance if available, or `nil` if no instance can be provided.
    func getInstance<T>(_ type: T.Type, name: String?) -> T?
}

public extension Resolver {
    /// Get an unnamed dependency of the specified type.  Returns the instance if available, or
    /// `nil` if no instance can be provided.
    /// - Note: When resolving a named dependency, use ``getInstance(_:name:)`` or
    /// ``getInstance(name:)`` instead.
    func getInstance<T>(_ type: T.Type) -> T? {
        return self.getInstance(type, name: nil)
    }
    
    /// Get a dependency of the implicit type, using the name for disambiguation. Returns the
    /// instance if available, or `nil` if no instance can be provided.
    /// - Note: If the inferred type is incorrect, or if Swift cannot infer the type, use
    /// ``getInstance(_:name:)`` or ``getInstance(_:)`` instead (which take the type as a
    /// parameter).
    func getInstance<T>(name: String? = nil) -> T? {
        return self.getInstance(T.self, name: name)
    }
}
