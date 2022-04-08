//
//  RegistrationConvertible.swift
//  swiftdi
//
//  Created by William Baker on 04/08/22.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

/// This protocol represents a type that may not be a `Registration` per se, but contains or can
/// produce one.
public protocol RegistrationConvertible {
    var registration: Registration { get }
}

// Default implementation for RegistrationConvertible, so that Registration classes don't need to
// implement it.
public extension RegistrationConvertible
where Self: Registration {
    var registration: Registration {
        return self
    }
}

/// A wrapper around a `Registration` object, intended for use with ``Factory/register(builder:)``.
public struct Service: RegistrationConvertible {
    public let registration: Registration
    
    /// - Parameters:
    ///   - scope: How often to call the registration callback.
    ///   - type: The type to register the service as. This may be different from the actual type of
    ///   the object, for example it may be the superclass, or a protocol that the object conforms
    ///   to.
    ///   - callback: How to retrieve or create an instance of the specified type. Takes one
    ///   argument, a `Resolver`, used for any further dependencies required for the creation of the
    ///   object.
    public init<T>(
        _ scope: Scope,
        _ type: T.Type,
        _ callback: @escaping (Resolver) -> T
    ) {
        switch scope {
        case .transient:
            self.registration = TransientRegistration(type, callback)
        case .singleton:
            self.registration = SingletonRegistration(type, callback)
        case .weak:
            self.registration = WeakRegistration(type, callback)
        }
    }
}
