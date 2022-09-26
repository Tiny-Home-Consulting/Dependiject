//
//  Store.swift
//  
//
//  Created by William Baker on 09/06/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import SwiftUI
import Combine

// The generic type names were chosen to match the SwiftUI equivalents:
// - ObjectType from StateObject<ObjectType> and ObservedObject<ObjectType>
// - Subject from ObservedObject.Wrapper.subscript<Subject>(dynamicMember:)
// - S from Publisher.receive<S>(on:options:)

/// A property wrapper used to wrap injected observable objects.
///
/// This is similar to SwiftUI's
/// [`StateObject`](https://developer.apple.com/documentation/swiftui/stateobject), but without
/// compile-time type restrictions. The lack of compile-time restrictions means that `ObjectType`
/// may be a protocol rather than a class.
///
/// - Important: At runtime, the wrapped value must conform to ``AnyObservableObject``.
///
/// To pass properties of the observable object down the view hierarchy as bindings, use the
/// projected value:
/// ```swift
/// struct ExampleView: View {
///     @Store var viewModel = Factory.shared.resolve(ViewModelProtocol.self)
///
///     var body: some View {
///         TextField("username", text: $viewModel.username)
///     }
/// }
/// ```
/// Not all injected objects need this property wrapper. See the example projects for examples each
/// way.
@propertyWrapper
public struct Store<ObjectType> {
    /// The underlying object being stored.
    public let wrappedValue: ObjectType
    
    // ObservedObject's wrappedValue is marked @MainActor. When using property wrapper syntax with
    // ObservedObject, as this did originally:
    //
    //     @ObservedObject internal var observableObject: ErasedObservableObject
    //
    // the entire thing is implicitly @MainActor. However, in order for the conformance to
    // DynamicProperty to be correct, _observableObject may not be actor-isolated. Hence, for
    // maximal correctness, this needs to be spelled out in full.
    fileprivate var _observableObject: ObservedObject<ErasedObservableObject>
    
    @MainActor internal var observableObject: ErasedObservableObject {
        return _observableObject.wrappedValue
    }
    
    /// A projected value which has the same properties as the wrapped value, but presented as
    /// bindings.
    ///
    /// Use this to pass bindings down the view hierarchy:
    /// ```swift
    /// struct ExampleView: View {
    ///     @Store var viewModel = Factory.shared.resolve(ViewModelProtocol.self)
    ///
    ///     var body: some View {
    ///         TextField("username", text: $viewModel.username)
    ///     }
    /// }
    /// ```
    @MainActor public var projectedValue: Wrapper {
        return Wrapper(self)
    }
    
    /// Create a stored value on a custom scheduler.
    ///
    /// Use this init to schedule updates on a specific scheduler other than `RunLoop.main`.
    ///
    /// - Note: When using this property wrapper within a view, you should always use
    /// ``init(wrappedValue:)``.
    public init<S: Scheduler>(
        wrappedValue: ObjectType,
        on scheduler: S,
        schedulerOptions: S.SchedulerOptions? = nil
    ) {
        self.wrappedValue = wrappedValue
        
        if let observable = wrappedValue as? AnyObservableObject {
            let objectWillChange = observable.objectWillChange
                .receive(on: scheduler, options: schedulerOptions)
                .eraseToAnyPublisher()
            self._observableObject = .init(initialValue: .init(objectWillChange: objectWillChange))
        } else {
            assertionFailure(
                "Only use the Store property wrapper with objects conforming to AnyObservableObject."
            )
            self._observableObject = .init(initialValue: .empty())
        }
    }
    
    /// Create a stored value which publishes on the main thread.
    ///
    /// To control when updates are published, see ``init(wrappedValue:on:schedulerOptions:)``.
    public init(wrappedValue: ObjectType) {
        self.init(wrappedValue: wrappedValue, on: RunLoop.main)
    }
    
    // This is the intended use of `@preconcurrency`. 
    /// An equivalent to SwiftUI's
    /// [`ObservedObject.Wrapper`](https://developer.apple.com/documentation/swiftui/observedobject/wrapper)
    /// type.
    @dynamicMemberLookup
    @preconcurrency
    @MainActor public struct Wrapper {
        private var store: Store
        
        internal init(_ store: Store<ObjectType>) {
            self.store = store
        }
        
        /// Returns a binding to the resulting value of a given key path.
        public subscript<Subject>(
            dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>
        ) -> Binding<Subject> {
            return Binding {
                self.store.wrappedValue[keyPath: keyPath]
            } set: {
                self.store.wrappedValue[keyPath: keyPath] = $0
            }
        }
    }
}

extension Store: DynamicProperty {
    public mutating func update() {
        _observableObject.update()
    }
}
