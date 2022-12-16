//
//  MultitypeService.swift
//  
//
//  Created by William Baker on 04/14/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

// MARK: Helper Types
/// A wrapper around the types & names for a multi-type registration.
internal enum RegistrationTypeList {
    case sharedName([Any.Type], String?)
    case individualNames(KeyValuePairs<Any.Type, String?>)
    
    internal var count: Int {
        switch self {
        case .sharedName(let arr, _):
            return arr.count
        case .individualNames(let kvp):
            return kvp.count
        }
    }
    
    internal func getName(for type: Any.Type) -> String?? {
        switch self {
        case .sharedName(let arr, let name):
            if arr.contains(where: { $0 == type }) {
                return .some(name)
            }
        case .individualNames(let kvp):
            if let last = kvp.last(where: { $0.key == type }) {
                return .some(last.value)
            }
        }
        return .none
    }
    
    internal func map<T>(_ transform: (Any.Type, String?) throws -> T) rethrows -> [T] {
        switch self {
        case .sharedName(let arr, let name):
            return try arr.map { try transform($0, name) }
        case .individualNames(let kvp):
            return try kvp.map(transform)
        }
    }
}

extension RegistrationTypeList: TextOutputStreamable {
    /// This is used by the string interpolation below to guarantee a consistent, unique name is
    /// generated. Rather than relying on the fact that different values produce different strings
    /// by default, manually write the associated values to the string.
    internal func write<Target: TextOutputStream>(to target: inout Target) {
        switch self {
        case .sharedName(let arr, let name):
            target.write(name.debugDescription)
            target.write(":")
            target.write(arr.description)
        case .individualNames(let kvp):
            target.write(kvp.description)
        }
    }
}

// MARK: Struct Declaration
/// A service that is exposed under multiple protocols.
///
/// This is for the use case that you have a single object, but want to expose only parts of it to
/// different parts of the application.
///
/// ### General Usage
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
/// ### Exposing the Implementation Type
///
/// By default, the original type is hidden. In the example above,
/// `Factory.shared.resolve(StateManager.self)` would fail. If resolving the original type is
/// desired, you may add the class itself to the type array:
/// ```swift
/// MultitypeService(exposedAs: [StateAccessor.self, StateUpdater.self, StateManager.self]) { _ in
///     StateManager()
/// }
/// ```
///
/// ### Usage with Named Dependencies
///
/// As with ``Service``, a MultitypeService may give its registrations names.
///
/// To use the same name for the dependency regardless of which interface is being resolved, use
/// ``init(exposedAs:name:callback:)`` or ``init(exposedAs:name:_:)``:
/// ```swift
/// Factory.register {
///     MultitypeService(
///         exposedAs: [StateAccessor.self, StateUpdater.self],
///         name: "MyStateManager"
///     ) { _ in
///         StateManager()
///     }
/// }
///
/// let myStateAccessor = Factory.shared.resolve(StateAccessor.self, name: "MyStateManager")
/// let myStateUpdater = Factory.shared.resolve(StateUpdater.self, name: "MyStateManager")
/// ```
///
/// To use a different name for each interface, use ``init(exposedAs:callback:)`` or
/// ``init(exposedAs:_:)``. Specify `nil` to allow the type to be resolved without a name:
/// ```swift
/// Factory.register {
///     MultitypeService(exposedAs: [
///         StateAccessor.self: nil,
///         StateUpdater.self: "MyStateUpdater"
///     ]) { _ in
///         StateManager()
///     }
/// }
///
/// let myStateAccessor = Factory.shared.resolve(StateAccessor.self)
/// let myStateUpdater = Factory.shared.resolve(StateUpdater.self, name: "MyStateUpdater")
/// ```
public struct MultitypeService<T: AnyObject> {
    private let exposedTypes: RegistrationTypeList
    private let getInstance: CallbackOrInstance<T>
    
    /// Create a registration exposed under multiple protocols.
    /// - Parameters:
    ///   - types: The types under which the object should be exposed.
    ///   - name: A service name which will be applied to all types the object is exposed as. See
    ///   ``Registration/name``.
    ///   - callback: The callback to use to create the shared instance of the dependency.
    /// - Important: The return type of the callback must be a subtype of every member of the
    /// `types` array. If this is not the case, attempting to resolve the instance will result in a
    /// fatal error.
    public init(
        exposedAs types: [Any.Type],
        name: String? = nil,
        callback: @escaping (Resolver) -> T
    ) {
        self.exposedTypes = .sharedName(types, name)
        self.getInstance = .callback(callback)
    }
    
    /// Create a registration exposed under multiple protocols.
    /// - Parameters:
    ///   - types: The types under which the object should be exposed.
    ///   - name: A service name which will be applied to all types the object is exposed as. See
    ///   ``Registration/name``.
    ///   - value: The shared instance of the dependency.
    /// - Important: The value must be a subtype of every member of the`types` array. If this is
    /// not the case, attempting to resolve the instance will result in a fatal error.
    public init(
        exposedAs types: [Any.Type],
        name: String? = nil,
        _ value: T
    ) {
        self.exposedTypes = .sharedName(types, name)
        self.getInstance = .instance(value)
    }
    
    /// Create a registration exposed under multiple protocols.
    /// - Parameters:
    ///   - interfaces: A map of the types this service is exposed as, and the name associated with
    ///   each type.
    ///   - callback: The callback to use to create the shared instance of the dependency.
    /// - Important: The return type of the callback must be a subtype of every key of the
    /// `interfaces` dictionary. If this is not the case, attempting to resolve the instance will
    /// result in a fatal error.
    public init(
        exposedAs interfaces: KeyValuePairs<Any.Type, String?>,
        callback: @escaping (Resolver) -> T
    ) {
        self.exposedTypes = .individualNames(interfaces)
        self.getInstance = .callback(callback)
    }
    
    /// Create a registration exposed under multiple protocols.
    /// - Parameters:
    ///   - interfaces: A map of the types this service is exposed as, and the name associated with
    ///   each type.
    ///   - value: The shared instance of the dependency.
    /// - Important: The return type of the callback must be a subtype of every key of the
    /// `interfaces` dictionary. If this is not the case, attempting to resolve the instance will
    /// result in a fatal error.
    public init(
        exposedAs interfaces: KeyValuePairs<Any.Type, String?>,
        _ value: T
    ) {
        self.exposedTypes = .individualNames(interfaces)
        self.getInstance = .instance(value)
    }
}

// MARK: Sequence Implementation
extension MultitypeService: Sequence {
    public typealias Element = Registration
    public typealias Iterator = AnyIterator<Registration>
    
    public var underestimatedCount: Int {
        // no need to underestimate, we know the count
        return exposedTypes.count + 1
    }
    
    public func makeIterator() -> Iterator {
        // handle allowing/hiding the original type
        var baseName: String?
        
        if let providedName = self.exposedTypes.getName(for: T.self) {
            // The class itself is also exposed.
            baseName = providedName
        } else {
            // The class itself is hidden; use a private name to do so.
            baseName = "__Multitype_\(self.exposedTypes)_\(T.self)"
        }
        
        var baseRegistration: Registration
        switch getInstance {
        case .instance(let value):
            baseRegistration = ConstantRegistration(T.self, baseName, value)
        case .callback(let callback):
            baseRegistration = SingletonRegistration(T.self, baseName, callback)
        }
        
        let arr = self.exposedTypes.map { type, elementName in
            TransientRegistration(type, elementName) { r in
                r.resolve(T.self, name: baseName)
            }
        } + CollectionOfOne(baseRegistration)
        
        return AnyIterator(arr.makeIterator())
    }
}
