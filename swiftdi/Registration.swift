//
//  Registration.swift
//  swiftdi
//
//  Created by William Baker on 04/04/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

public protocol Registration {
    /// A workaround for the associated type system. `getInstance()` should return something of this
    /// type. This should always return the same type.
    var type: Any.Type { get }
    /// Retrieve or create the actual instance. Provided a `Resolver`, in case the creation of the
    /// instance requires further dependencies.
    func getInstance(resolver: Resolver) -> Any
}

/// An abstraction around a registration that manages its scope. Do not create this directly;
/// instead, initialize one of its subclasses.
internal class BaseRegistration: Registration {
    /// The actual return type of `getInstance` and `create`.
    ///
    /// This class would be generic, but Swift doesn't let you create a heterogeneous array of a
    /// generic type. You can have an array typed as `[Registration<Int>]`, but not
    /// `[any Registration]`.
    internal let type: Any.Type
    internal let create: (Resolver) -> Any
    
    internal init<T>(create: @escaping (Resolver) -> T) {
        self.create = create
        self.type = T.self
    }
    
    internal func getInstance(resolver: Resolver) -> Any {
        fatalError("Must implement in subclass")
    }
}

/// A registration corresponding to the `weak` scope.
internal class WeakRegistration: BaseRegistration {
    private weak var instance: AnyObject?
    
    internal override func getInstance(resolver: Resolver) -> Any {
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
internal class TransientRegistration: BaseRegistration {
    internal override func getInstance(resolver: Resolver) -> Any {
        return create(resolver)
    }
}

/// A registration corresponding to the `singleton` scope.
internal class SingletonRegistration: BaseRegistration {
    private var instance: Any?
    
    internal override func getInstance(resolver: Resolver) -> Any {
        if let instance = instance {
            return instance
        } else {
            instance = create(resolver)
            return instance!
        }
    }
}
