//
//  Factory.swift
//  swiftdi
//
//  Created by William Baker on 04/04/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

/// The class to which you register dependencies.
public class Factory: Resolver {
    private var registrations: [Registration] = []
    
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
    ///         ViewModel(networkManager: r.getInstance()!)
    ///     }
    /// }
    /// ```
    /// Custom `Registration` and ``RegistrationConvertible`` objects can be created inside the
    /// closure, in the same way that ``Service`` is in the example.
    public static func register(@RegistrationBuilder builder: () -> [Registration]) {
        self.shared.registrations += builder()
    }
    
    public func getInstance<T>(_ type: T.Type, name: String?) -> T? {
        if let index = getIndex(type: type, name: name) {
            return registrations[index].getInstance(resolver: self) as? T
        } else {
            return nil
        }
    }
    
    /// Get the index within `registrations` where the specified type and name are registered.
    private func getIndex(type: Any.Type, name: String?) -> Int? {
        return registrations.lastIndex {
            return $0.type == type && $0.name == name
        }
    }
}
