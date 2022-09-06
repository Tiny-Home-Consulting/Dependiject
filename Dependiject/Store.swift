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

/// A property wrapper similar to SwiftUI's
/// [`StateObject`](https://developer.apple.com/documentation/swiftui/stateobject), but without
/// compile-time type restrictions.
///
/// Use this property wrapper to wrap observables which are injected. Unlike `StateObject`, this
/// does not have any constraints at compile-time, which allows the wrapped type to be a protocol.
///
/// - Important: At runtime, the wrapped value must conform to `AnyObservableObject`. Though not
/// enforced at compile-time, this is enforced at runtime.
///
/// Injected objects which are not observable do not need to be given a property wrapper.
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
@propertyWrapper
public struct Store<ObjectType> {
    /// The underlying object being stored.
    public let wrappedValue: ObjectType
    
    @ObservedObject private var observableObject: ErasedObservableObject
    
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
    public var projectedValue: Wrapper {
        return Wrapper(self)
    }
    
    /// Create a stored value on a custom scheduler.
    ///
    /// Use this init when it is not desirable to always present updates on the main thread. This
    /// should not be necessary within a view.
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
            self.observableObject = .init(objectWillChange: objectWillChange)
        } else {
            assertionFailure(
                "Only use the Store property wrapper with objects conforming to AnyObservableObject."
            )
            self.observableObject = .empty()
        }
    }
    
    /// Create a value that is stored on the main thread.
    ///
    /// To control when updates are published, see ``init(wrappedValue:on:schedulerOptions:)``.
    public init(wrappedValue: ObjectType) {
        self.init(wrappedValue: wrappedValue, on: RunLoop.main)
    }
    
    /// An equivalent to SwiftUI's
    /// [`ObservedObject.Wrapper`](https://developer.apple.com/documentation/swiftui/observedobject/wrapper)
    /// type.
    @dynamicMemberLookup
    public struct Wrapper {
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
