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
/// This is used by the ``Factory`` for sanity checks, such as detecting circular dependencies and
/// validating scopes.
public enum ErrorCheckMode: Sendable, Hashable {
    // Adding more cases to this enum is a breaking change that can only happen for major releases;
    // see https://github.com/Tiny-Home-Consulting/Dependiject/issues/67 for an explanation.
    
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
public struct ResolutionOptions: Sendable {
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
    /// Whether to allow a singleton service to depend on a weak service.
    public var singletonAcceptsWeak: Bool
    
    /// The memberwise initializer.
    public init(
        mode: ErrorCheckMode = .debugOnly,
        maxDepth: UInt = 100,
        singletonAcceptsWeak: Bool = false
    ) {
        self.mode = mode
        self.maxDepth = maxDepth
        self.singletonAcceptsWeak = singletonAcceptsWeak
    }
}

internal func enforceCondition(
    _ mode: ErrorCheckMode,
    _ condition: @autoclosure () -> Bool,
    _ message: @autoclosure () -> String,
    file: StaticString = #file,
    line: UInt = #line
) {
    switch mode {
    case .never:
        return
    case .debugOnly:
        assert(condition(), message(), file: file, line: line)
    case .always:
        if !condition() {
            fatalError(message(), file: file, line: line)
        }
    }
}

internal protocol SingletonCheckingResolver: Resolver {
    func beginResolvingForSingleton()
    func endResolvingForSingleton()
    func isResolvingForSingleton() -> Bool
}

/// The class to which you register dependencies.
public final class Factory: SingletonCheckingResolver, @unchecked Sendable {
    private let lock = NSRecursiveLock()
    private var registrations: [Registration] = []
    private var resolutionDepth: UInt = 0
    private var singletonDepth: UInt = 0
    private var options = ResolutionOptions()
    
    /// The singleton instance of the factory, used for dependency resolution.
    public static let shared = Factory()
    
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
    public static func register(@RegistrationBuilder builder: () -> [Registration]) {
        shared.lock.lock()
        shared.registrations += builder()
        shared.lock.unlock()
    }
    
    /// Resets the factory, clearing all dependencies.
    ///
    /// This is mostly meant for testing; you could call this from your test class's `setUp()` or
    /// `setUpWithError()` method.
    public static func clearDependencies() {
        shared.lock.lock()
        
        assert(shared.resolutionDepth == 0, "Cannot reset dependencies while resolving.")
        shared.registrations = []
        
        shared.lock.unlock()
    }
    
    /// Retrieve the current resolution options.
    ///
    /// Do not use this as a basis to make changes; use ``updateOptions(mutation:)`` instead.
    public static func getOptions() -> ResolutionOptions {
        shared.lock.lock()
        defer {
            shared.lock.unlock()
        }
        
        return shared.options
    }
    
    /// Change the current resolution options.
    ///
    /// This method may be used to atomically make adjustments, or to entirely overwrite the
    /// options:
    /// ```swift
    /// Factory.updateOptions { options in
    ///     // increase the max resolution depth
    ///     options.maxDepth += 5
    /// }
    ///
    /// Factory.updateOptions { options in
    ///     // initialize new options
    ///     options = ResolutionOptions(mode: .always, maxDepth: 200)
    /// }
    /// ```
    public static func updateOptions(mutation: (inout ResolutionOptions) throws -> Void) rethrows {
        shared.lock.lock()
        defer {
            shared.lock.unlock()
        }
        
        try mutation(&shared.options)
    }
    
    public func resolve<T>(_ type: T.Type, name: String?) -> T {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        guard let index = getIndex(type: type, name: name) else {
            let nameToDisplay = name?.debugDescription ?? "nil"
            preconditionFailure(
                "Could not resolve dependency of type \(type) with name \(nameToDisplay)."
            )
        }
        
        resolutionDepth += 1
        defer {
            resolutionDepth -= 1
        }
        
        enforceCondition(
            options.mode,
            resolutionDepth < options.maxDepth,
            """
            Error: resolution depth exceeded maximum expected value (resolving \(
                type
            ) with name \(
                name?.debugDescription ?? "nil"
            ))
            """
        )
        
        return registrations[index].resolve(self) as! T
    }
    
    internal func beginResolvingForSingleton() {
        singletonDepth += 1
    }
    
    internal func endResolvingForSingleton() {
        singletonDepth -= 1
    }
    
    internal func isResolvingForSingleton() -> Bool {
        return singletonDepth != 0
    }
    
    /// Get the index within `registrations` where the specified type and name are registered.
    private func getIndex(type: Any.Type, name: String?) -> Int? {
        return registrations.lastIndex {
            $0.type == type && $0.name == name
        }
    }
}
