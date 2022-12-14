//
//  Util.swift
//  Dependiject
//
//  Created by William Baker on 12/14/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

internal enum CallbackOrInstance<T> {
    case callback((Resolver) -> T)
    case instance(T)
}
