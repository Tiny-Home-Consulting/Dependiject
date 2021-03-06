//
//  Registration.swift
//  Dependiject
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
/// class CustomRegistration: Registration {
///     let type: Any.Type
///     let name: String?
///     let callback: (Resolver) -> Any
///
///     var shouldReuse: Bool
///     private var instance: Any?
///
///     func resolve(_ resolver: Resolver) -> Any {
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
/// Although reference semantics are not required -- that is, the custom registration can be a
/// struct rather than a class -- the `resolve(_:)` method must be non-mutating for value types.
public protocol Registration: RegistrationConvertible {
    /// A workaround for the associated type system.
    ///
    /// ``resolve(_:)`` should return something of this type. This should always return the same
    /// type.
    var type: Any.Type { get }
    /// The name of the object, used for disambiguating registrations to the same type. Usually `nil`.
    var name: String? { get }
    /// Retrieve or create the actual instance. Provided a `Resolver`, in case the creation of the
    /// instance requires further dependencies.
    func resolve(_ resolver: Resolver) -> Any
}

/// A registration corresponding to the `weak` scope.
internal class WeakRegistration: Registration {
    internal let type: Any.Type
    internal let name: String?
    private let callback: (Resolver) -> Any
    
    private weak var instance: AnyObject?
    
    internal init(_ type: Any.Type, _ name: String?, _ callback: @escaping (Resolver) -> Any) {
        self.type = type
        self.name = name
        self.callback = callback
    }
    
    internal func resolve(_ resolver: Resolver) -> Any {
        if let retval = self.instance {
            return retval
        } else {
            let value = callback(resolver)
            
            assert(Swift.type(of: value) is AnyClass, "Cannot register value type as weak")
            instance = value as AnyObject
            
            return value
        }
    }
}

/// A registration corresponding to the `transient` scope.
/// - Remark: Since this doesn't track any state, `resolve(_:)` is non-mutating, and this can be a
/// struct. Right now it's a class for consistency with the other two, but this isn't necessary.
internal class TransientRegistration: Registration {
    internal let type: Any.Type
    internal let name: String?
    private let callback: (Resolver) -> Any
    
    internal init(_ type: Any.Type, _ name: String?, _ callback: @escaping (Resolver) -> Any) {
        self.type = type
        self.name = name
        self.callback = callback
    }
    
    internal func resolve(_ resolver: Resolver) -> Any {
        return callback(resolver)
    }
}

/// A registration corresponding to the `singleton` scope.
internal class SingletonRegistration: Registration {
    internal let type: Any.Type
    internal let name: String?
    private let callback: (Resolver) -> Any
    
    private var instance: Any?
    
    internal init(_ type: Any.Type, _ name: String?, _ callback: @escaping (Resolver) -> Any) {
        self.type = type
        self.name = name
        self.callback = callback
    }
    
    internal func resolve(_ resolver: Resolver) -> Any {
        if let instance = self.instance {
            return instance
        } else {
            instance = callback(resolver)
            return instance!
        }
    }
}
