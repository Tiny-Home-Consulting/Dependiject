//
//  Registration.swift
//  swiftdi
//
//  Created by William Baker on 04/04/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

/// This protocol represents a single entry in the factory's registrations list. Generally you don't
/// use this directly, and call `registerService(type:scope:callback:)` or register a `Service`
/// instance instead.
///
/// In some cases, the provided scopes may not be sufficient. In such cases, you may implement the
/// `Registration` protocol, and add it to the factory using the `registerService(_:)` method.
///
/// For example, the following registration uses a boolean variable to determine when to re-use the
/// existing instance:
///
///     class CustomRegistration: Registration {
///         let type: Any.Type
///         let callback: (Resolver) -> Any
///
///         var shouldReuse: Bool
///         private var instance: Any?
///
///         func getInstance(resolver: Resolver) -> Any {
///             if shouldReuse,
///                let instance = self.instance {
///                 return instance
///             } else {
///                 instance = callback(resolver)
///                 return instance!
///             }
///         }
///     }
///
/// Although reference semantics are not required -- that is, the custom registration can be a
/// struct rather than a class -- the `getInstance(resolver:)` method must be non-mutating for value
/// types.
public protocol Registration {
    /// A workaround for the associated type system. `getInstance()` should return something of this
    /// type. This should always return the same type.
    var type: Any.Type { get }
    /// Retrieve or create the actual instance. Provided a `Resolver`, in case the creation of the
    /// instance requires further dependencies.
    func getInstance(resolver: Resolver) -> Any
}

/// A wrapper around a `Registration` object, intended for use with `Factory.register(_:)`.
public struct Service: Registration {
    private let backingValue: Registration
    
    public var type: Any.Type {
        return backingValue.type
    }
    
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
            self.backingValue = TransientRegistration(type, callback)
        case .singleton:
            self.backingValue = SingletonRegistration(type, callback)
        case .weak:
            self.backingValue = WeakRegistration(type, callback)
        }
    }
    
    public func getInstance(resolver: Resolver) -> Any {
        return backingValue.getInstance(resolver: resolver)
    }
}

/// A registration corresponding to the `weak` scope.
internal class WeakRegistration: Registration {
    internal let type: Any.Type
    private let callback: (Resolver) -> Any
    
    private weak var instance: AnyObject?
    
    internal init<T>(_ type: T.Type, _ callback: @escaping (Resolver) -> T) {
        self.type = type
        self.callback = callback
    }
    
    internal func getInstance(resolver: Resolver) -> Any {
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
/// - Remark: Since this doesn't track any state, `getInstance(resolver:)` is non-mutating, and this
/// can be a struct. Right now it's a class for consistency with the other two, but this isn't necessary.
internal class TransientRegistration: Registration {
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
internal class SingletonRegistration: Registration {
    internal let type: Any.Type
    private let callback: (Resolver) -> Any
    
    private var instance: Any?
    
    internal init<T>(_ type: T.Type, _ callback: @escaping (Resolver) -> T) {
        self.type = type
        self.callback = callback
    }
    
    internal func getInstance(resolver: Resolver) -> Any {
        if let instance = self.instance {
            return instance
        } else {
            instance = callback(resolver)
            return instance!
        }
    }
}
