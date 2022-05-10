//
//  ObservableObjectPublisher.swift
//  Dependiject_Tests
//
//  Created by Wesley Boyd on 5/9/22.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import Swift

public enum Subscribers {
    public struct Demand : Equatable, Comparable, Hashable, Codable, CustomStringConvertible {
        public static let unlimited: Subscribers.Demand
        public static let none: Subscribers.Demand
        public static func max(_ value: Int) -> Subscribers.Demand
        public var description: String { get }
        public static func + (lhs: Subscribers.Demand, rhs: Subscribers.Demand) -> Subscribers.Demand
        public static func += (lhs: inout Subscribers.Demand, rhs: Subscribers.Demand)
        public static func + (lhs: Subscribers.Demand, rhs: Int) -> Subscribers.Demand
        public static func += (lhs: inout Subscribers.Demand, rhs: Int)
        public static func * (lhs: Subscribers.Demand, rhs: Int) -> Subscribers.Demand
        public static func *= (lhs: inout Subscribers.Demand, rhs: Int)
        public static func - (lhs: Subscribers.Demand, rhs: Subscribers.Demand) -> Subscribers.Demand
        public static func -= (lhs: inout Subscribers.Demand, rhs: Subscribers.Demand)
        public static func - (lhs: Subscribers.Demand, rhs: Int) -> Subscribers.Demand
        public static func -= (lhs: inout Subscribers.Demand, rhs: Int)
        public static func > (lhs: Subscribers.Demand, rhs: Int) -> Bool
        public static func >= (lhs: Subscribers.Demand, rhs: Int) -> Bool
        public static func > (lhs: Int, rhs: Subscribers.Demand) -> Bool
        public static func >= (lhs: Int, rhs: Subscribers.Demand) -> Bool
        public static func < (lhs: Subscribers.Demand, rhs: Int) -> Bool
        public static func < (lhs: Int, rhs: Subscribers.Demand) -> Bool
        public static func <= (lhs: Subscribers.Demand, rhs: Int) -> Bool
        public static func <= (lhs: Int, rhs: Subscribers.Demand) -> Bool
        public static func < (lhs: Subscribers.Demand, rhs: Subscribers.Demand) -> Bool
        public static func <= (lhs: Subscribers.Demand, rhs: Subscribers.Demand) -> Bool
        public static func >= (lhs: Subscribers.Demand, rhs: Subscribers.Demand) -> Bool
        public static func > (lhs: Subscribers.Demand, rhs: Subscribers.Demand) -> Bool
        public static func == (lhs: Subscribers.Demand, rhs: Int) -> Bool
        public static func != (lhs: Subscribers.Demand, rhs: Int) -> Bool
        public static func == (lhs: Int, rhs: Subscribers.Demand) -> Bool
        public static func != (lhs: Int, rhs: Subscribers.Demand) -> Bool
        public var max: Int? { get }
        public init(from decoder: Decoder) throws
        public func encode(to encoder: Encoder) throws
        public static func == (a: Subscribers.Demand, b: Subscribers.Demand) -> Bool
        public func hash(into hasher: inout Hasher)
        public var hashValue: Int { get }
    }
    public enum Completion<Failure> where Failure : Error {
        case finished
        case failure(Failure)
    }
}

public protocol Subscription : Cancellable, CustomCombineIdentifierConvertible {
    func request(_ demand: Subscribers.Demand)
}

public protocol Subscriber : CustomCombineIdentifierConvertible {
    associatedtype Input
    associatedtype Failure : Error
    func receive(subscription: Subscription)
    func receive(_ input: Self.Input) -> Subscribers.Demand
    func receive(completion: Subscribers.Completion<Self.Failure>)
}

public protocol Publisher {
    associatedtype Output
    associatedtype Failure : Error
    func receive<S>(subscriber: S)
    where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input
}

extension Never: Error {}

final public class ObservableObjectPublisher : Publisher {
    public typealias Output = Void
    public typealias Failure = Never
    public init()
    final public func receive<S>(subscriber: S)
    where S : Subscriber, S.Failure == Never, S.Input == Void
    final public func send()
}
