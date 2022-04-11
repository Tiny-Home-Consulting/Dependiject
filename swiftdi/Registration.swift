//
//  Registration.swift
//  swiftdi
//
//  Created by William Baker on 04/04/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

/// A single entry in the factory's registrations list.
///
/// Generally you don't use this directly, and instead create a ``Service``. You use a custom
/// conformance to this protocol when the provided scopes are insufficient for your use case.
///
/// For example, the following registration uses a boolean variable to determine when to re-use the
/// existing instance:
/// ```swift
/// struct CustomRegistration: Registration {
///     let type: Any.Type
///     let callback: (Resolver) -> Any
///
///     var shouldReuse: Bool
///     private var instance: Any?
///
///     func getInstance(resolver: Resolver) -> Any {
///         if shouldReuse,
///            let instance = self.instance {
///             return instance
///         } else {
///             instance = callback(resolver)
///             return instance!
///         }
///     }
/// }
/// ```
public protocol Registration: RegistrationConvertible {
    /// A workaround for the associated type system.
    ///
    /// ``getInstance(resolver:)`` should return something of this type. This should always return
    /// the same type.
    var type: Any.Type { get }
    /// Retrieve or create the actual instance. Provided a `Resolver`, in case the creation of the
    /// instance requires further dependencies.
    mutating func getInstance(resolver: Resolver) -> Any
}

/// A registration corresponding to the `weak` scope.
internal struct WeakRegistration: Registration {
    internal let type: Any.Type
    private let callback: (Resolver) -> Any
    
    private weak var instance: AnyObject?
    
    internal init<T>(_ type: T.Type, _ callback: @escaping (Resolver) -> T) {
        self.type = type
        self.callback = callback
    }
    
    internal mutating func getInstance(resolver: Resolver) -> Any {
        if let retval = self.instance {
            return retval
        } else {
            let value = callback(resolver)
            instance = value as AnyObject
            return value
        }
    }
}

/// A registration corresponding to the `transient` scope.
internal struct TransientRegistration: Registration {
    internal let type: Any.Type
    private let callback: (Resolver) -> Any
    
    internal init<T>(_ type: T.Type, _ callback: @escaping (Resolver) -> T) {
        self.type = type
        self.callback = callback
    }
    
    internal func getInstance(resolver: Resolver) -> Any {
        return callback(resolver)
    }
}

/// A registration corresponding to the `singleton` scope.
internal struct SingletonRegistration: Registration {
    internal let type: Any.Type
    private let callback: (Resolver) -> Any
    
    private var instance: Any?
    
    internal init<T>(_ type: T.Type, _ callback: @escaping (Resolver) -> T) {
        self.type = type
        self.callback = callback
    }
    
    internal mutating func getInstance(resolver: Resolver) -> Any {
        if let instance = self.instance {
            return instance
        } else {
            instance = callback(resolver)
            return instance!
        }
    }
}
