//
//  StoreTests.swift
//  
//
//  Created by William Baker on 09/15/2022.
//

import XCTest
import EntwineTest
import Combine
@testable import Dependiject

fileprivate class TestObservable: ObservableObject, AnyObservableObject {
    var setterCalled = false
    
    private var _setterTracked = 0
    var setterTracked: Int {
        get {
            return _setterTracked
        }
        set {
            setterCalled = true
            _setterTracked = newValue
        }
    }
    
    @Published var published = 0
    var notPublished = 0
}

@MainActor final class StoreTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
    }
    
    func test_projectedValue_bindsWrappedValue() {
        // This test does not subscribe to the publisher, so the scheduler used doesn't matter.
        @Store var observable = TestObservable()
        
        $observable.setterTracked.wrappedValue = 1
        
        XCTAssertTrue(
            observable.setterCalled,
            "Updating property of projectedValue should call wrappedValue property setter"
        )
        XCTAssertEqual(
            observable.setterTracked,
            $observable.setterTracked.wrappedValue,
            "wrappedValue property should match projectedValue property"
        )
    }
    
    func test_settingPublishedValue_causesUpdate() {
        var updated = false
        let scheduler = TestScheduler()
        @Store(on: scheduler) var observable = TestObservable()
        
        // This must be stored somewhere. If we discard it it will automatically unsubscribe from
        // the observable.
        let cancellable = _observable.observableObject.objectWillChange.sink { _ in
            updated = true
        }
        
        observable.published = 1
        XCTAssertFalse(updated, "Update should publish only when the given scheduler allows it")
        scheduler.resume()
        XCTAssertTrue(updated, "Update should be published when @Published property is changed")
        
        // This silences a warning that this variable is never used. As mentioned above, it must
        // exist.
        _ = cancellable
    }
    
    func test_settingNonPublishedValue_doesNotCauseUpdate() {
        var updated = false
        // For this test, if any results are published, they should be published immediately.
        @Store(on: ImmediateScheduler.shared) var observable = TestObservable()
        
        let cancellable = _observable.observableObject.objectWillChange.sink { _ in
            updated = true
        }
        
        observable.notPublished = 1
        XCTAssertFalse(updated, "Update should not be sent when non-@Published property is changed")
        
        _ = cancellable
    }
}
