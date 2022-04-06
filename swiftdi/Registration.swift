//
//  Registration.swift
//  swiftdi
//
//  Created by William Baker on 04/04/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

/// This protocol represents a single entry in the factory's registrations list. Generally you don't
/// use this directly, and use `registerService(type:scope:callback:)` instead.
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
public protocol Registration {
    /// A workaround for the associated type system. `getInstance()` should return something of this
    /// type. This should always return the same type.
    var type: Any.Type { get }
    /// Retrieve or create the actual instance. Provided a `Resolver`, in case the creation of the
    /// instance requires further dependencies.
    func getInstance(resolver: Resolver) -> Any
}

/// An abstraction around a closure-backed registration that manages its scope. Do not create this
/// directly; instead, initialize one of its subclasses.
public class BaseRegistration: Registration {
    /// The actual return type of `getInstance` and `create`.
    ///
    /// This class would be generic, but Swift doesn't let you create a heterogeneous array of a
    /// generic type. You can have an array typed as `[Registration<Int>]`, but not
    /// `[any Registration]`.
    public let type: Any.Type
    internal let create: (Resolver) -> Any
    
    internal init<T>(create: @escaping (Resolver) -> T) {
        self.create = create
        self.type = T.self
    }
    
    public func getInstance(resolver: Resolver) -> Any {
        fatalError("Must implement in subclass")
    }
}

/// A registration corresponding to the `weak` scope.
public class WeakRegistration: BaseRegistration {
    private weak var instance: AnyObject?
    
    public init<T>(_: T.Type, _ callback: @escaping (Resolver) -> T) {
        super.init(create: callback)
    }
    
    public override func getInstance(resolver: Resolver) -> Any {
        if let retval = instance {
            return retval
        } else {
            let value = create(resolver)
            instance = value as AnyObject
            return value
        }
    }
}

/// A registration corresponding to the `transient` scope.
public class TransientRegistration: BaseRegistration {
    public init<T>(_: T.Type, _ callback: @escaping (Resolver) -> T) {
        super.init(create: callback)
    }
    
    public override func getInstance(resolver: Resolver) -> Any {
        return create(resolver)
    }
}

/// A registration corresponding to the `singleton` scope.
public class SingletonRegistration: BaseRegistration {
    private var instance: Any?
    
    public init<T>(_: T.Type, _ callback: @escaping (Resolver) -> T) {
        super.init(create: callback)
    }
    
    public override func getInstance(resolver: Resolver) -> Any {
        if let instance = instance {
            return instance
        } else {
            instance = create(resolver)
            return instance!
        }
    }
}
