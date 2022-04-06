//
//  Factory.swift
//  swiftdi
//
//  Created by William Baker on 04/04/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

/// The class to which you register dependencies.
public class Factory: Resolver {
    private var registrations: [Registration] = []
    
    /// The singleton instance of the factory.
    public static let shared = Factory()
    
    private init() {
    }
    
    /// Create a new registration.
    /// - Parameters:
    ///   - type: The type to register the service as. This may be different from the actual type of
    ///   the object, for example it may be the superclass, or a protocol that the object conforms
    ///   to.
    ///   - scope: How often to call the registration callback.
    ///   - callback: How to retrieve or create an instance of the specified type. Takes one
    ///   argument, a `Resolver`, used for any further dependencies required for the creation of the
    ///   object.
    public func registerService<T>(
        type: T.Type,
        scope: Scope,
        callback: @escaping (Resolver) -> T
    ) {
        switch scope {
        case .transient:
            registerService(
                TransientRegistration(create: callback)
            )
        case .singleton:
            registerService(
                SingletonRegistration(create: callback)
            )
        case .weak:
            registerService(
                WeakRegistration(create: callback)
            )
        }
    }
    
    /// Register a service with a custom registration manager. Generally you don't call this
    /// overload directly; see the documentation for `Registration` for details.
    public func registerService(_ registration: Registration) {
        if let index = getIndex(for: registration.type) {
            registrations[index] = registration
        } else {
            registrations.append(registration)
        }
    }
    
    public func getInstance<T>(_ type: T.Type) -> T? {
        if let index = getIndex(for: type) {
            return registrations[index].getInstance(resolver: self) as? T
        } else {
            return nil
        }
    }
    
    /// Get the index within `registrations` where the specified type is registered.
    private func getIndex(for type: Any.Type) -> Int? {
        return registrations.lastIndex(where: { $0.type == type })
    }
}
