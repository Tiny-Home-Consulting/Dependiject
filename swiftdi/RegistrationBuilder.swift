//
//  RegistrationBuilder.swift
//  swiftdi
//
//  Created by William Baker on 04/06/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

@resultBuilder
public struct RegistrationBuilder {
    public typealias Component = [Registration]
    public typealias Expression = Registration
    
    public static func buildExpression(_ expression: Registration) -> [Registration] {
        return [expression]
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
