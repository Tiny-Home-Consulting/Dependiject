//
//  Scope.swift
//  swiftdi
//
//  Created by William Baker on 04/04/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

public enum Scope {
    /// Call the provided callback every time the dependency is requested.
    case transient
    /// Create a lazy-loaded singleton, and re-use the same one for further requests.
    /// - Note: This scope is for singletons that are created by the callback. If the singleton is
    /// created elsewhere and the callback only accesses it, `transient` is more memory-efficient.
    case singleton
    /// Re-use an existing instance if it exists, but do not hold onto an unused instance.
    case weak
}
