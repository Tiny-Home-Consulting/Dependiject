//
//  Store.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//  MIT License

import SwiftUI
import Combine

@propertyWrapper
public struct Store<Model>: DynamicProperty {
    
    // MARK: Nested types
    @dynamicMemberLookup
    public struct Wrapper {
        
        fileprivate var store: Store
        
        public subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<Model, Value>) -> Binding<Value> {
            Binding(get: { self.store.wrappedValue[keyPath: keyPath] },
                    set: { self.store.wrappedValue[keyPath: keyPath] = $0 })
        }
        
    }
    
    // MARK: Stored properties
    public let wrappedValue: Model
    
    @ObservedObject
    private var observableObject: ErasedObservableObject
    
    // MARK: Computed Properties
    public var projectedValue: Wrapper {
        Wrapper(store: self)
    }
    
    // MARK: Initialization
    // Usage example: @Store(on: RunLoop.main) var foo = Foo()
    public init<S: Scheduler>(
        wrappedValue: Model,
        on scheduler: S,
        schedulerOptions: S.SchedulerOptions? = nil
    ) {
        self.wrappedValue = wrappedValue
        
        if let objectWillChange = (wrappedValue as? AnyObservableObject)?.objectWillChange {
            self.observableObject = .init(
                objectWillChange: objectWillChange.receive(on: scheduler, options: schedulerOptions)
                    .eraseToAnyPublisher()
            )
        } else {
            assertionFailure("Only use the `Store` property wrapper with instances conforming to `AnyObservableObject`.")
            self.observableObject = .empty()
        }
    }
    
    public init(wrappedValue: Model) {
        self.init(wrappedValue: wrappedValue, on: RunLoop.main)
    }
    
    // MARK: Methods
    public mutating func update() {
        _observableObject.update()
    }
    
}
