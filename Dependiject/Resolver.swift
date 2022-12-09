//
//  Resolver.swift
//  Dependiject
//
//  Created by William Baker on 04/04/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

/// A container that can provide dependencies, but is not necessarily responsible for registering or
/// creating them.
public protocol Resolver {
    /// Get a dependency of the specified type, using the name for disambiguation.
    /// - Precondition: A registration with the given type and name exists.
    /// - Returns: The instance of the type with the given name.
    func resolve<T>(_ type: T.Type, name: String?) -> T
    /// Get all resolvable dependencies of the specified type.
    ///
    /// If you know the name of the desired dependency, it is more efficient to use
    /// ``resolve(_:name:)`` than this method.
    ///
    /// - Note: The code samples in the documentation for this method require Swift 5.7. This method
    /// is usable in Swift 5.5 if the protocol in question does not have associated types.
    ///
    /// This function is intended to be used for cases where you need to operate on many instances
    /// of a common protocol. For example, the `resetAllState` method below finds and resets all
    /// `StateManager` instances:
    /// ```swift
    /// protocol StateManager<State> {
    ///     associatedtype State
    ///     var state: State { get }
    ///     func reset()
    /// }
    ///
    /// func resetAllState() {
    ///     let stateManagers = Factory.shared.resolveAll((any StateManager).self)
    ///     for (name, manager) in stateManagers {
    ///         print("Resetting state for \(name)")
    ///         manager.reset()
    ///     }
    /// }
    /// ```
    /// As with ``resolve(_:name:)``, this only returns registrations whose static type matches the
    /// argument and whose name is unique for its type. Compare the following registrations:
    /// ```swift
    /// // This would NOT work: even though the instances conform to StateManager, they are not
    /// // registered as such.
    /// Factory.shared.register {
    ///     Service(.singleton, FirstStateManagerImplementation.self) { _ in
    ///         FirstStateManagerImplementation()
    ///     }
    ///
    ///     Service(.singleton, SecondStateManagerImplementation.self) { _ in
    ///         SecondStateManagerImplementation()
    ///     }
    /// }
    ///
    /// // This would NOT work:
    /// // (any StateManager<FirstState>).self == (any StateManager<SecondState>).self at runtime,
    /// // so the second state manager replaces the first one!
    /// Factory.shared.register {
    ///     Service(.singleton, (any StateManager<FirstState>).self) { _ in
    ///         FirstStateManagerImplementation()
    ///     }
    ///
    ///     Service(.singleton, (any StateManager<SecondState>).self) { _ in
    ///         SecondStateManagerImplementation()
    ///     }
    /// }
    ///
    /// // This would work: they're registered under the same protocol with different names.
    /// Factory.shared.register {
    ///     Service(.singleton, (any StateManager).self, name: "first") { _ in
    ///         FirstStateManagerImplementation()
    ///     }
    ///
    ///     Service(.singleton, (any StateManager).self, name: "second") { _ in
    ///         SecondStateManagerImplementation()
    ///     }
    /// }
    /// ```
    /// - Returns: A dictionary whose keys are the registrations' names and whose values are the
    /// objects requested.
    func resolveAll<T>(_ type: T.Type) -> [String?: T]
}

public extension Resolver {
    /// Get an unnamed dependency of the specified type.
    /// - Returns: The unnamed instance of the type.
    /// - Important: There must be an unnamed registration of the specified type. When resolving a
    /// named dependency, use ``resolve(_:name:)`` or ``Resolver/resolve(name:)`` instead.
    func resolve<T>(_ type: T.Type) -> T {
        return self.resolve(type, name: nil)
    }
    
    /// Get a dependency of the implicit type, using the name for disambiguation.
    /// - Precondition: A registration exists with the specified name and inferred type.
    /// - Returns: The instance of the type with the given name.
    /// 
    /// If the inferred type is incorrect, or if Swift cannot infer the type, use
    /// ``resolve(_:name:)`` or ``resolve(_:)`` instead (which take the type as a parameter).
    func resolve<T>(name: String? = nil) -> T {
        return self.resolve(T.self, name: name)
    }
    
    /// This overload fixes compiler errors.
    ///
    /// To explicitly specify the type, use ``resolve(_:name:)`` or ``resolve(_:)`` instead.
    ///
    /// Without this overload, adding extraneous arguments to an `init` inside of the callback
    /// passed to ``Service/init(_:_:name:_:)`` does not error at the `init` call, but at the top
    /// of the ``Factory/register(builder:)`` block.
    ///
    /// - Remark: This overload does not show up in the documentation because it is explicitly
    /// marked `unavailable`.
    @available(*, unavailable, message: """
        Could not determine expected type. Explicitly specify with resolve(_:) or resolve(_:name:).
        """)
    func resolve(name: String? = nil) -> Any {
        preconditionFailure("Could not determine type to resolve.")
    }
}
