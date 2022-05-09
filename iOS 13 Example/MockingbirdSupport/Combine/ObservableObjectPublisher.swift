//
//  SecondaryViewModelTests.swift
//  Dependiject_Tests
//
//  Created by Wesley Boyd on 5/9/22.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import Swift

public enum Subscribers {
    public struct Demand : Equatable, Comparable, Hashable, Codable, CustomStringConvertible {

        /// A request for as many values as the publisher can produce.
        public static let unlimited: Subscribers.Demand

        /// A request for no elements from the publisher.
        ///
        /// This is equivalent to `Demand.max(0)`.
        public static let none: Subscribers.Demand

        /// Creates a demand for the given maximum number of elements.
        ///
        /// The publisher is free to send fewer than the requested maximum number of elements.
        ///
        /// - Parameter value: The maximum number of elements. Providing a negative value for this parameter results in a fatal error.
        public static func max(_ value: Int) -> Subscribers.Demand

        /// A textual representation of this instance.
        ///
        /// Calling this property directly is discouraged. Instead, convert an
        /// instance of any type to a string by using the `String(describing:)`
        /// initializer. This initializer works with any type, and uses the custom
        /// `description` property for types that conform to
        /// `CustomStringConvertible`:
        ///
        ///     struct Point: CustomStringConvertible {
        ///         let x: Int, y: Int
        ///
        ///         var description: String {
        ///             return "(\(x), \(y))"
        ///         }
        ///     }
        ///
        ///     let p = Point(x: 21, y: 30)
        ///     let s = String(describing: p)
        ///     print(s)
        ///     // Prints "(21, 30)"
        ///
        /// The conversion of `p` to a string in the assignment to `s` uses the
        /// `Point` type's `description` property.
        public var description: String { get }

        /// Returns the result of adding two demands.
        /// When adding any value to `.unlimited`, the result is `.unlimited`.
        public static func + (lhs: Subscribers.Demand, rhs: Subscribers.Demand) -> Subscribers.Demand

        /// Adds two demands, and assigns the result to the first demand.
        ///
        /// When adding any value to `.unlimited`, the result is `.unlimited`.
        public static func += (lhs: inout Subscribers.Demand, rhs: Subscribers.Demand)

        /// Returns the result of adding an integer to a demand.
        ///
        /// When adding any value to `.unlimited`, the result is `.unlimited`.
        public static func + (lhs: Subscribers.Demand, rhs: Int) -> Subscribers.Demand

        /// Adds an integer to a demand, and assigns the result to the demand.
        ///
        /// When adding any value to `.unlimited`, the result is `.unlimited`.
        public static func += (lhs: inout Subscribers.Demand, rhs: Int)

        /// Returns the result of multiplying a demand by an integer.
        ///
        /// When multiplying any value by `.unlimited`, the result is `.unlimited`. If
        /// the multiplication operation overflows, the result is `.unlimited`.
        public static func * (lhs: Subscribers.Demand, rhs: Int) -> Subscribers.Demand

        /// Multiplies a demand by an integer, and assigns the result to the demand.
        ///
        /// When multiplying any value by `.unlimited`, the result is `.unlimited`. If
        /// the multiplication operation overflows, the result is `.unlimited`.
        public static func *= (lhs: inout Subscribers.Demand, rhs: Int)

        /// Returns the result of subtracting one demand from another.
        ///
        /// When subtracting any value (including `.unlimited`) from `.unlimited`, the result is still `.unlimited`. Subtracting `.unlimited` from any value (except `.unlimited`) results in `.max(0)`. A negative demand is impossible; when an operation would result in a negative value, Combine adjusts the value to `.max(0)`.
        public static func - (lhs: Subscribers.Demand, rhs: Subscribers.Demand) -> Subscribers.Demand

        /// Subtracts one demand from another, and assigns the result to the first demand.
        ///
        /// When subtracting any value (including `.unlimited`) from `.unlimited`, the result is still `.unlimited`. Subtracting `.unlimited` from any value (except `.unlimited`) results in `.max(0)`. A negative demand is impossible; when an operation would result in a negative value, Combine adjusts the value to `.max(0)`.
        public static func -= (lhs: inout Subscribers.Demand, rhs: Subscribers.Demand)

        /// Returns the result of subtracting an integer from a demand.
        ///
        /// When subtracting any value from `.unlimited`, the result is still `.unlimited`. A negative demand is possible, but be aware that it isn't usable when requesting values in a subscription.
        public static func - (lhs: Subscribers.Demand, rhs: Int) -> Subscribers.Demand

        /// Subtracts an integer from a demand, and assigns the result to the demand.
        ///
        /// When subtracting any value from `.unlimited`, the result is still `.unlimited`. A negative demand is impossible; when an operation would result in a negative value, Combine adjusts the value to `.max(0)`.
        public static func -= (lhs: inout Subscribers.Demand, rhs: Int)

        /// Returns a Boolean that indicates whether the demand requests more than the given number of elements.
        ///
        /// If `lhs` is `.unlimited`, then the result is always `true`. Otherwise, the operator compares the demand’s `max` value to `rhs`.
        public static func > (lhs: Subscribers.Demand, rhs: Int) -> Bool

        /// Returns a Boolean that indicates whether the first demand requests more or the same number of elements as the second.
        ///
        /// If `lhs` is `.unlimited`, then the result is always `true`. Otherwise, the operator compares the demand’s `max` value to `rhs`.
        public static func >= (lhs: Subscribers.Demand, rhs: Int) -> Bool

        /// Returns a Boolean that indicates a given number of elements is greater than the maximum specified by the demand.
        ///
        /// If `rhs` is `.unlimited`, then the result is always `false`. Otherwise, the operator compares the demand’s `max` value to `lhs`.
        public static func > (lhs: Int, rhs: Subscribers.Demand) -> Bool

        /// Returns a Boolean that indicates a given number of elements is greater than or equal to the maximum specified by the demand.
        ///
        /// If `rhs` is `.unlimited`, then the result is always `false`. Otherwise, the operator compares the demand’s `max` value to `lhs`.
        public static func >= (lhs: Int, rhs: Subscribers.Demand) -> Bool

        /// Returns a Boolean that indicates whether the demand requests fewer than the given number of elements.
        ///
        /// If `lhs` is `.unlimited`, then the result is always `false`. Otherwise, the operator compares the demand’s `max` value to `rhs`.
        public static func < (lhs: Subscribers.Demand, rhs: Int) -> Bool

        /// Returns a Boolean that indicates a given number of elements is less than the maximum specified by the demand.
        ///
        /// If `rhs` is `.unlimited`, then the result is always `true`. Otherwise, the operator compares the demand’s `max` value to `lhs`.
        public static func < (lhs: Int, rhs: Subscribers.Demand) -> Bool

        /// Returns a Boolean that indicates whether the demand requests fewer or the same number of elements as the given integer.
        ///
        /// If `lhs` is `.unlimited`, then the result is always `false`. Otherwise, the operator compares the demand’s `max` value to `rhs`.
        public static func <= (lhs: Subscribers.Demand, rhs: Int) -> Bool

        /// Returns a Boolean value that indicates a given number of elements is less than or equal the maximum specified by the demand.
        ///
        /// If `rhs` is `.unlimited`, then the result is always `true`. Otherwise, the operator compares the demand’s `max` value to `lhs`.
        public static func <= (lhs: Int, rhs: Subscribers.Demand) -> Bool

        /// Returns a Boolean that indicates whether the first demand requests fewer elements than the second.
        ///
        /// If both sides are `.unlimited`, the result is always `false`. If `lhs` is `.unlimited`, then the result is always `false`. If `rhs` is `.unlimited` then the result is always `true`. Otherwise, this operator compares the demands’ `max` values.
        public static func < (lhs: Subscribers.Demand, rhs: Subscribers.Demand) -> Bool

        /// Returns a Boolean value that indicates whether the first demand requests fewer or the same number of elements as the second.
        ///
        /// If both sides are `.unlimited`, the result is always `true`. If `lhs` is `.unlimited`, then the result is always `false`. If `rhs` is unlimited then the result is always `true`. Otherwise, this operator compares the demands’ `max` values.
        public static func <= (lhs: Subscribers.Demand, rhs: Subscribers.Demand) -> Bool

        /// Returns a Boolean that indicates whether the first demand requests more or the same number of elements as the second.
        ///
        /// If both sides are `.unlimited`, the result is always `true`. If `lhs` is `.unlimited`, then the result is always `true`. If `rhs` is `.unlimited` then the result is always `false`. Otherwise, this operator compares the demands’ `max` values.
        public static func >= (lhs: Subscribers.Demand, rhs: Subscribers.Demand) -> Bool

        /// Returns a Boolean that indicates whether the first demand requests more elements than the second.
        ///
        /// If both sides are `.unlimited`, the result is always `false`. If `lhs` is `.unlimited`, then the result is always `true`. If `rhs` is `.unlimited` then the result is always `false`. Otherwise, this operator compares the demands’ `max` values.
        public static func > (lhs: Subscribers.Demand, rhs: Subscribers.Demand) -> Bool

        /// Returns a Boolean value that indicates whether a demand requests the given number of elements.
        ///
        /// An `.unlimited` demand doesn’t match any integer.
        public static func == (lhs: Subscribers.Demand, rhs: Int) -> Bool

        /// Returns a Boolean value that indicates whether a demand isn't equal to an integer.
        ///
        /// The `.unlimited` value isn’t equal to any integer.
        public static func != (lhs: Subscribers.Demand, rhs: Int) -> Bool

        /// Returns a Boolean value that indicates whether a given number of elements matches the request of a given demand.
        ///
        /// An `.unlimited` demand doesn’t match any integer.
        public static func == (lhs: Int, rhs: Subscribers.Demand) -> Bool

        /// Returns a Boolean value that indicates whether an integer is unequal to a demand.
        ///
        /// The `.unlimited` value isn’t equal to any integer.
        public static func != (lhs: Int, rhs: Subscribers.Demand) -> Bool

        /// The number of requested values.
        ///
        /// The value is `nil` if the demand is ``Subscribers/Demand/unlimited``.
        public var max: Int? { get }

        /// Creates a demand instance from a decoder.
        ///
        /// - Parameter decoder: The decoder of a previously-encoded ``Subscribers/Demand`` instance.
        public init(from decoder: Decoder) throws

        /// Encodes the demand to the provide encoder.
        ///
        /// - Parameter encoder: An encoder instance.
        public func encode(to encoder: Encoder) throws

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (a: Subscribers.Demand, b: Subscribers.Demand) -> Bool

        /// Hashes the essential components of this value by feeding them into the
        /// given hasher.
        ///
        /// Implement this method to conform to the `Hashable` protocol. The
        /// components used for hashing must be the same as the components compared
        /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
        /// with each of these components.
        ///
        /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
        ///   compile-time error in the future.
        ///
        /// - Parameter hasher: The hasher to use when combining the components
        ///   of this instance.
        public func hash(into hasher: inout Hasher)

        /// The hash value.
        ///
        /// Hash values are not guaranteed to be equal across different executions of
        /// your program. Do not save hash values to use during a future execution.
        ///
        /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
        ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
        public var hashValue: Int { get }
    }
    public enum Completion<Failure> where Failure : Error {
        /// The publisher finished normally.
        case finished

        /// The publisher stopped publishing due to the indicated error.
        case failure(Failure)
    }
}

public protocol Subscription : Cancellable, CustomCombineIdentifierConvertible {

    /// Tells a publisher that it may send more values to the subscriber.
    func request(_ demand: Subscribers.Demand)
}

public protocol Subscriber : CustomCombineIdentifierConvertible {

    /// The kind of values this subscriber receives.
    associatedtype Input

    /// The kind of errors this subscriber might receive.
    ///
    /// Use `Never` if this `Subscriber` cannot receive errors.
    associatedtype Failure : Error

    /// Tells the subscriber that it has successfully subscribed to the publisher and may request items.
    ///
    /// Use the received ``Subscription`` to request items from the publisher.
    /// - Parameter subscription: A subscription that represents the connection between publisher and subscriber.
    func receive(subscription: Subscription)

    /// Tells the subscriber that the publisher has produced an element.
    ///
    /// - Parameter input: The published element.
    /// - Returns: A `Subscribers.Demand` instance indicating how many more elements the subscriber expects to receive.
    func receive(_ input: Self.Input) -> Subscribers.Demand

    /// Tells the subscriber that the publisher has completed publishing, either normally or with an error.
    ///
    /// - Parameter completion: A ``Subscribers/Completion`` case indicating whether publishing completed normally or with an error.
    func receive(completion: Subscribers.Completion<Self.Failure>)
}

public protocol Publisher {

    /// The kind of values published by this publisher.
    associatedtype Output

    /// The kind of errors this publisher might publish.
    ///
    /// Use `Never` if this `Publisher` does not publish errors.
    associatedtype Failure : Error

    /// Attaches the specified subscriber to this publisher.
    ///
    /// Implementations of ``Publisher`` must implement this method.
    ///
    /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
    ///
    /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
    func receive<S>(subscriber: S)
    where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input
}

extension Never: Error {}

final public class ObservableObjectPublisher : Publisher {

    /// The kind of values published by this publisher.
    public typealias Output = Void

    /// The kind of errors this publisher might publish.
    ///
    /// Use `Never` if this `Publisher` does not publish errors.
    public typealias Failure = Never

    /// Creates an observable object publisher instance.
    public init()

    /// Attaches the specified subscriber to this publisher.
    ///
    /// Implementations of ``Publisher`` must implement this method.
    ///
    /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
    ///
    /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
    final public func receive<S>(subscriber: S)
    where S : Subscriber, S.Failure == Never, S.Input == Void

    /// Sends the changed value to the downstream subscriber.
    final public func send()
}
