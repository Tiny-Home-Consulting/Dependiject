//
//  Scope.swift
//  swiftdi
//
//  Created by William Baker on 04/04/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

/// The different lifecycles for dependencies that are provided by default.
///
/// This is meant to be used with ``Service/init(_:_:_:)``; each case describes a different way of
/// determining when the callback should be called vs. when the previous return value should be
/// re-used.
public enum Scope {
    /// Call the provided callback every time the dependency is requested.
    case transient
    /// Create a lazy-loaded singleton, and re-use the same one for further requests.
    /// - Note: This scope is for singletons that are created by the callback. If the singleton is
    /// created elsewhere and the callback only accesses it, ``transient`` is more memory-efficient.
    case singleton
    /// Re-use an existing instance if it exists, but do not hold onto an unused instance.
    /// - Note: Although the type system permits using this with a value type (struct, enum, or
    /// tuple), this only works for a reference type (class or actor). For value types, this behaves
    /// the same as ``transient``.
    case weak
}
