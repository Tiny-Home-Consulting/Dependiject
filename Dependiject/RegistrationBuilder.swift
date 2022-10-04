//
//  RegistrationBuilder.swift
//  Dependiject
//
//  Created by William Baker on 04/06/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

/// A result builder that collects [Registrations](/documentation/dependiject/registration) and
/// [RegistrationConvertibles](/documentation/dependiject/registrationconvertible), and produces a
/// list of registrations usable by the factory.
///
/// This result builder is solely used for the ``Factory/register(builder:)`` method. See the
/// documentation there for details.
@resultBuilder
public enum RegistrationBuilder {
    public typealias Component = [Registration]
    
    public static func buildArray(_ components: [[Registration]]) -> [Registration] {
        return components.flatMap { $0 }
    }
    
    public static func buildBlock(_ components: [Registration]...) -> [Registration] {
        return components.flatMap { $0 }
    }
    
    public static func buildEither(first component: [Registration]) -> [Registration] {
        return component
    }
    
    public static func buildEither(second component: [Registration]) -> [Registration] {
        return component
    }
    
    public static func buildExpression(_ expression: RegistrationConvertible) -> [Registration] {
        return [expression.registration]
    }
    
    public static func buildExpression<S: Sequence>(_ expression: S) -> [Registration]
    where S.Element: RegistrationConvertible {
        return expression.map(\.registration)
    }
    
    // These overloads prevent "protocol as a type cannot conform to the protocol itself" errors
    public static func buildExpression<S: Sequence>(_ expression: S) -> [Registration]
    where S.Element == RegistrationConvertible {
        return expression.map(\.registration)
    }
    
    public static func buildExpression<S: Sequence>(_ expression: S) -> [Registration]
    where S.Element == Registration {
        return Array(expression)
    }
    
    public static func buildOptional(_ component: [Registration]?) -> [Registration] {
        return component ?? []
    }
    
// MARK: Uniqueness checking
    
    public typealias FinalResult = [Registration]
    
    public static func buildFinalResult(_ component: [Registration]) -> [Registration] {
        var seenRegistrations: Set<RegistrationIdentifier> = []
        
        // reverse before filtering, so that later registrations override earlier ones
        return component.reversed()
            .filter { registration in
                seenRegistrations.insert(
                    RegistrationIdentifier(registration)
                ).inserted
            }
    }
}

internal struct RegistrationIdentifier: Hashable {
    private let name: String?
    private let type: ObjectIdentifier // since Any.Type isn't hashable
    
    internal init(_ registration: Registration) {
        self.name = registration.name
        self.type = ObjectIdentifier(registration.type)
    }
}
