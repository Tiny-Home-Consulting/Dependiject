//
//  RegistrationConvertible.swift
//  Dependiject
//
//  Created by William Baker on 04/08/22.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

/// An object or structure that can produce a `Registration`.
///
/// If you wanted to, for example, use different names for different scopes (instead of calling them
/// all `Service`), you could write custom implementations such as the following:
/// ```swift
/// struct Singleton: RegistrationConvertible {
///     private let service: Service
///
///     var registration: Registration {
///         return service.registration
///     }
///
///     init<T>(_ type: T.Type, _ callback: @escaping (Resolver) -> T) {
///         self.service = Service(.singleton, type, callback)
///     }
/// }
/// ```
/// Then, you can use your custom type in ``Factory/register(builder:)``:
/// ```swift
/// Factory.register {
///     Singleton(DependencyProtocol.self) { _ in
///         DependencyClass()
///     }
/// }
/// ```
public protocol RegistrationConvertible {
    /// The wrapped registration object.
    /// - Note: The default implementation is only available for types that adopt `Registration`.
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

/// The different lifecycles for dependencies that are provided by default.
///
/// This is meant to be used with ``Service/init(_:_:_:_:)``; each case describes a different way of
/// determining when the callback should be called vs. when the previous return value should be
/// re-used.
public enum Scope {
    /// Call the provided callback every time the dependency is requested.
    case transient
    /// Create a lazy-loaded singleton, and re-use the same one for further requests.
    /// - Note: This scope is for singletons that are created by the callback. If the singleton is
    /// created elsewhere and the callback only accesses it, ``transient`` is more memory-efficient.
    case singleton
    /// Re-use an existing instance if it exists, but do not hold onto an unused instance.
    /// - Note: Although the type system permits using this with a value type (struct, enum, or
    /// tuple), this only works for a reference type (class or actor). For value types, this behaves
    /// the same as ``transient``.
    case weak
}

/// A wrapper around a `Registration` object, intended for use with ``Factory/register(builder:)``.
public struct Service: RegistrationConvertible {
    public let registration: Registration
    
    /// - Parameters:
    ///   - scope: How often to call the registration callback.
    ///   - type: The type to register the service as. This may be different from the actual type of
    ///   the object, for example it may be the superclass, or a protocol that the object conforms
    ///   to.
    ///   - name: The name to give the registration object. This can usually be `nil`; it is only
    ///   necessary when registering two different services of the same type.
    ///   - callback: How to retrieve or create an instance of the specified type. Takes one
    ///   argument, a `Resolver`, used for any further dependencies required for the creation of the
    ///   object.
    public init<T>(
        _ scope: Scope,
        _ type: T.Type,
        _ name: String? = nil,
        _ callback: @escaping (Resolver) -> T
    ) {
        switch scope {
        case .transient:
            self.registration = TransientRegistration(type, name, callback)
        case .singleton:
            self.registration = SingletonRegistration(type, name, callback)
        case .weak:
            self.registration = WeakRegistration(type, name, callback)
        }
    }
}
