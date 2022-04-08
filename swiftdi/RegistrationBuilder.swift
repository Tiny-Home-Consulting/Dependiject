//
//  RegistrationBuilder.swift
//  swiftdi
//
//  Created by William Baker on 04/06/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

/// A result builder that collects `Registration`s and ``RegistrationConvertible``s, and produces
/// a list of registrations usable by the factory.
///
/// This result builder is solely used for the ``Factory/register(builder:)`` method. See the
/// documentation there for details.
@resultBuilder
public enum RegistrationBuilder {
    public typealias Component = [Registration]
    
    public static func buildExpression(_ expression: RegistrationConvertible) -> [Registration] {
        return [expression.registration]
    }
    
    public static func buildOptional(_ component: [Registration]?) -> [Registration] {
        return component ?? []
    }
    
    public static func buildBlock(_ components: [Registration]...) -> [Registration] {
        return components.flatMap { $0 }
    }
    
    public static func buildArray(_ components: [[Registration]]) -> [Registration] {
        return components.flatMap { $0 }
    }
}
