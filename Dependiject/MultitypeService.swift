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
public struct MultitypeService<T: AnyObject> {
    fileprivate let exposedTypes: [Any.Type]
    fileprivate let callback: (Resolver) -> T
    
    /// Create a registration exposed under multiple protocols.
    /// - Parameters:
    ///   - types: The types under which the object should be exposed.
    ///   - callback: The callback to use to create the shared instance of the dependency.
    /// - Important: The return type of the callback must be a subtype of every member of the 
    /// `types` array.
    ///
    /// Currently, if one of the types in the array is not a supertype of `T`, then attempting to
    /// resolve an instance of that type will result in `nil` (as if it had never been registered).
    /// However, a future version may have an assertion, precondition, or even compile-time type
    /// check to prevent such a registration, so this behavior should not be relied upon.
    public init(
        exposedAs types: [Any.Type],
        callback: @escaping (Resolver) -> T
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
        let arr = self.exposedTypes.map { type in
            TransientRegistration(type, nil) { r in
                r.getInstance(T.self)!
            }
        } + CollectionOfOne<Registration>(
            SingletonRegistration(T.self, nil, self.callback)
        )
        
        return arr.makeIterator()
    }
}
