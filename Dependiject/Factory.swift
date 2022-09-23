//
//  Factory.swift
//  Dependiject
//
//  Created by William Baker on 04/04/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import Foundation

/// When to check for errors.
///
/// This is used by the ``Factory`` to determine whether to error if the calls to
/// ``Factory/resolve(_:name:)`` exceed a certain depth.
public enum ErrorCheckMode {
    /// Never perform any error checking.
    case never
    /// Error check using
    /// [`assert(_:_:file:line:)`](https://developer.apple.com/documentation/swift/assert(_:_:file:line:)),
    /// so that it is only performed in builds without optimizations.
    ///
    /// Building without optimizations (i.e. using `-Onone`) is the default for Xcode playgrounds
    /// and for debug builds, but not for production builds.
    case debugOnly
    /// Always perform error checking, even in optimized release builds.
    case always
}

/// The options struct used by the ``Factory`` to configure error checks.
public struct ResolutionOptions {
    /// The mode used to check for errors.
    public var mode: ErrorCheckMode
    /// The maximum depth of the dependency tree.
    ///
    /// If resolving a dependency takes at least this number of steps, program execution may be
    /// terminated, depending on the value of ``mode``. This will usually happen because of circular
    /// dependencies, e.g:
    /// ```swift
    /// Factory.register {
    ///    Service(.weak, Foo.self) { r in
    ///        Foo(bar: r.resolve())
    ///    }
    ///
    ///    Service(.weak, Bar.self) { r in
    ///        Bar(foo: r.resolve())
    ///    }
    /// }
    /// ```
    public var maxDepth: UInt
    
    // the implicit init would be internal rather than public
    public init(mode: ErrorCheckMode, maxDepth: UInt) {
        self.mode = mode
        self.maxDepth = maxDepth
    }
}

/// The class to which you register dependencies.
public final class Factory: Resolver, @unchecked Sendable {
    private var registrations: [Registration] = []
    private var resolutionDepth: UInt = 0
    
    /// The singleton instance of the factory, used for dependency resolution.
    public static let shared = Factory()
    
    /// The options used to check for circular dependencies.
    ///
    /// The default value is `(mode: .debugOnly, maxDepth: 100)`.
    public static var options: ResolutionOptions = .init(mode: .debugOnly, maxDepth: 100)
    
    /// The lock used to prevent simultaneous calls to ``register(builder:)``.
    private static var lock = NSLock()
    
    private init() {
    }
    
    /// Register several services at once.
    ///
    /// The closure collects any instances created in it and registers them all at once. For
    /// example, when registering view models that have no dependencies, one could say:
    /// ```swift
    /// Factory.register {
    ///     Service(.weak, FirstViewModel.self) { _ in
    ///         FirstViewModel()
    ///     }
    ///
    ///     Service(.weak, SecondViewModel.self) { _ in
    ///         SecondViewModel()
    ///     }
    /// }
    /// ```
    /// Dependencies that themselves have further dependencies can use the argument passed into the
    /// closure to resolve them:
    /// ```swift
    /// Factory.register {
    ///     Service(.singleton, NetworkManager.self) { _ in
    ///         NetworkManager()
    ///     }
    ///
    ///     Service(.weak, ViewModel.self) { r in
    ///         ViewModel(networkManager: r.resolve())
    ///     }
    /// }
    /// ```
    /// Custom `Registration` and ``RegistrationConvertible`` objects can be created inside the
    /// closure, in the same way that ``Service`` is in the example.
    ///
    /// It is also possible to use a sequence of registration-convertible objects, such as a
    /// `[Registration]`, as a top-level expression. For an example of this, see
    /// ``MultitypeService``.
    ///
    /// This method should always be called from the same thread. If this is simultaneously called
    /// from two separate threads, one will block until the other finishes.
    public static func register(@RegistrationBuilder builder: () -> [Registration]) {
        lock.lock()
        self.shared.registrations += builder()
        lock.unlock()
    }
    
    public func resolve<T>(_ type: T.Type, name: String?) -> T {
        guard let index = getIndex(type: type, name: name) else {
            let nameToDisplay = name?.debugDescription ?? "nil"
            preconditionFailure(
                "Could not resolve dependency of type \(type) with name \(nameToDisplay)."
            )
        }
        
        return Util.runOnMainThreadAndWait {
            resolutionDepth += 1
            Util.enforceCondition(
                Self.options.mode,
                resolutionDepth < Self.options.maxDepth,
                """
                Error: resolution depth exceeded maximum expected value (resolving \(
                    type
                ) with name \(
                    name?.debugDescription ?? "nil"
                ))
                """
            )
            defer {
                resolutionDepth -= 1
            }
            
            return registrations[index].resolve(self)
        } as! T
    }
    
    /// Get the index within `registrations` where the specified type and name are registered.
    private func getIndex(type: Any.Type, name: String?) -> Int? {
        return registrations.lastIndex {
            $0.type == type && $0.name == name
        }
    }
}
