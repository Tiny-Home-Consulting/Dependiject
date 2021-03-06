//
//  Store.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//  MIT License

import SwiftUI

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
    public init(wrappedValue: Model) {
        self.wrappedValue = wrappedValue
        
        if let objectWillChange = (wrappedValue as? AnyObservableObject)?.objectWillChange {
            self.observableObject = .init(objectWillChange: objectWillChange.eraseToAnyPublisher())
        } else {
            assertionFailure("Only use the `Store` property wrapper with instances conforming to `AnyObservableObject`.")
            self.observableObject = .empty()
        }
    }
    
    // MARK: Methods
    public mutating func update() {
        _observableObject.update()
    }
    
}
