//
//  Utils.swift
//  
//  Created by William Baker on 09/23/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import Foundation

internal enum Util {
    internal static func enforceCondition(
        _ mode: ErrorCheckMode,
        _ condition: @autoclosure () -> Bool,
        _ message: @autoclosure () -> String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        switch mode {
        case .never:
            return
        case .debugOnly:
            assert(condition(), message(), file: file, line: line)
        case .always:
            if !condition() {
                fatalError(message(), file: file, line: line)
            }
        }
    }
    
    internal static func runOnMainThreadAndWait<T>(
        action: @MainActor () throws -> T
    ) rethrows -> T {
        if Thread.isMainThread {
            /*
             * This is running on the main thread, but it takes some work to convince Swift's
             * thread-safety checker of this. For now, I'm passing it to an @preconcurrency func,
             * which disables Swift's actor isolation checking. In general this can be unsafe (hence
             * the name of the method), but in this specific case we know we're on the main thread.
             */
            return try unsafeExecuteWithoutActorChecking(action)
        } else {
            return try DispatchQueue.main.sync(execute: action)
        }
    }
    
    @preconcurrency
    private static func unsafeExecuteWithoutActorChecking<T>(
        _ action: () throws -> T
    ) rethrows -> T {
        return try action()
    }
}
