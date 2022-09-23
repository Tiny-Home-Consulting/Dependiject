//
//  MultitypeService.swift
//  
//
//  Created by William Baker on 04/14/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

/// A service that is exposed under multiple protocols.
///
/// This is for the use case that you have a single object, but want to expose only parts of it to
/// different parts of the application.
///
/// In the following example, there's one class `StateManager` responsible for managing some shared
/// piece of state, which is exposed to different parts of the code under the protocols
/// `StateAccessor` and `StateUpdater`:
/// ```swift
/// Factory.register {
///     MultitypeService(exposedAs: [StateAccessor.self, StateUpdater.self]) { _ in
///         StateManager()
///     }
/// }
/// ```
/// As this type of registration only works as expected for reference types, the callback must
/// return an object (as opposed to a struct). If Swift cannot or does not correctly infer the
/// generic type, you may explicitly specify (e.g. `MultitypeService<StateManager>` rather than just
/// `MultitypeService`).
///
/// By default, the original type is hidden. In the example above,
/// `Factory.shared.resolve(StateManager.self)` would fail. If resolving the original type is
/// desired, you may add the class itself to the type array:
/// ```swift
/// MultitypeService(exposedAs: [StateAccessor.self, StateUpdater.self, StateManager.self]) { _ in
///     StateManager()
/// }
/// ```
public struct MultitypeService<T: AnyObject> {
    fileprivate let exposedTypes: [Any.Type]
    fileprivate let callback: @MainActor (Resolver) -> T
    
    /// Create a registration exposed under multiple protocols.
    /// - Parameters:
    ///   - types: The types under which the object should be exposed.
    ///   - callback: The callback to use to create the shared instance of the dependency. This
    ///   closure will always run on the main thread.
    /// - Important: The return type of the callback must be a subtype of every member of the
    /// `types` array. If this is not the case, attempting to resolve the instance will result in a
    /// fatal error.
    public init(
        exposedAs types: [Any.Type],
        callback: @MainActor @escaping (Resolver) -> T
    ) {
        self.exposedTypes = types
        self.callback = callback
    }
}

extension MultitypeService: Sequence {
    public typealias Element = Registration
    public typealias Iterator = Array<Registration>.Iterator
    
    public var underestimatedCount: Int {
        // no need to underestimate, we know the count
        return exposedTypes.count + 1
    }
    
    public func makeIterator() -> Iterator {
        // handle allowing/hiding the original type
        var name: String?
        
        if self.exposedTypes.contains(where: { $0 == T.self }) {
            // The class itself is also exposed.
            name = nil
        } else {
            // The class itself is hidden; use a private name to do so.
            name = "__Multitype_\(self.exposedTypes)_\(T.self)"
        }
        
        let arr = self.exposedTypes.map { type in
            TransientRegistration(type, nil) { r in
                r.resolve(T.self, name: name)
            }
        } + CollectionOfOne<Registration>(
            SingletonRegistration(T.self, name, self.callback)
        )
        
        return arr.makeIterator()
    }
}
