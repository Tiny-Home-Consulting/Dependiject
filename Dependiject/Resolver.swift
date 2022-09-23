//
//  Resolver.swift
//  Dependiject
//
//  Created by William Baker on 04/04/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

/// A container that can provide dependencies, but is not necessarily responsible for registering or
/// creating them.
public protocol Resolver {
    /// Get a dependency of the specified type, using the name for disambiguation.
    /// - Precondition: A registration with the given type and name exists.
    /// - Returns: The instance of the type with the given name.
    /// - Warning: This method is not thread-safe. In Swift 5.5+ (Xcode 13.2+), you may use
    /// ``Resolver/resolve(_:name:)-4w8d6`` to ensure thread safety.
    func resolve<T>(_ type: T.Type, name: String?) -> T
}

public extension Resolver {
    /// Get an unnamed dependency of the specified type.
    /// - Returns: The unnamed instance of the type.
    ///
    /// There must be an unnamed registration of the specified type. When resolving a named
    /// dependency, use ``Resolver/resolve(_:name:)-7dkag`` or ``resolve(name:)`` instead.
    /// - Warning: This method is not thread-safe. In Swift 5.5+ (Xcode 13.2+), you may use
    /// ``Resolver/resolve(_:name:)-4w8d6`` to ensure thread safety.
    func resolve<T>(_ type: T.Type) -> T {
        return self.resolve(type, name: nil)
    }
    
    /// Get a dependency of the implicit type, using the name for disambiguation.
    /// - Precondition: A registration exists with the specified name and inferred type.
    /// - Returns: The instance of the type with the given name.
    /// 
    /// If the inferred type is incorrect, or if Swift cannot infer the type, use
    /// ``Resolver/resolve(_:name:)-7dkag`` or ``resolve(_:)`` instead (which take the type as a
    /// parameter).
    /// - Warning: This method is not thread-safe. In Swift 5.5+ (Xcode 13.2+), you may use
    /// ``Resolver/resolve(_:name:)-4w8d6`` to ensure thread safety.
    func resolve<T>(name: String? = nil) -> T {
        return self.resolve(T.self, name: name)
    }
    
#if swift(>=5.5)
    /// Get a dependency of the specified type, using the name for disambiguation.
    /// - Precondition: A registration with the given type and name exists.
    /// - Returns: The instance of the type with the given name.
    @available(swift 5.5)
    func resolve<T: Sendable>(_ type: T.Type = T.self, name: String? = nil) async -> T {
        return await MainActor.run {
            self.resolve(type, name: name)
        }
    }
#endif
}
