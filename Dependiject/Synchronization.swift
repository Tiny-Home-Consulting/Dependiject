//
//  Synchronization.swift
//
//
//  Created by Riley Baker on 9/5/24.
//

import Foundation

/// A type that serializes work to prevent data races.
public protocol Synchronizer {
    /// Synchronize some work with other calls to this method.
    ///
    /// No two closures passed to this method may run at the same time. How this is achieved is up
    /// to the implementation. For example, ``LockSynchronizer`` uses a recursive lock for
    /// serialization without enforcing particulars about threads or executors.
    ///
    /// If you know that all dependencies will be resolved on the main thread, and want to enforce
    /// this, you could write an implementation that calls
    /// [`MainActor.assumeIsolated(_:file:line:)`](https://developer.apple.com/documentation/swift/mainactor/assumeisolated(_:file:line:)-swift.type.method)
    /// or asserts
    /// [`Thread.isMainThread`](https://developer.apple.com/documentation/foundation/thread/1412704-ismainthread),
    /// for example.
    ///
    /// - Important: This method may be called recursively. Therefore, do not use a synchronization
    /// construct that deadlocks if called recursively, such as `NSLock.withLock` or
    /// `DispatchQueue.main.sync`.
    @Sendable
    func synchronize<T>(_ body: () throws -> T) rethrows -> T
}

/// A synchronizer that uses
/// [`NSRecursiveLock`](https://developer.apple.com/documentation/foundation/nsrecursivelock)
/// to ensure synchronization.
public struct LockSynchronizer: Synchronizer, Sendable {
    private let lock = NSRecursiveLock()
    
    @Sendable
    public func synchronize<T>(_ body: () throws -> T) rethrows -> T {
        lock.lock()
        defer {
            lock.unlock()
        }
        return try body()
    }
}
