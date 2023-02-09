//
//  StorableValue.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 28/3/21.
//

import Foundation


/// This must be implemented by all the types that must be stored in UserDefaults
/// Most of the types can be directly stored but some of them, like enums, can't and
/// we must implement this protocol to conver to/from a storable value
public
protocol StorableValue {
    associatedtype ValueToStore = Self
    
    func to() -> ValueToStore
    static func from(_: ValueToStore) -> Self
}

extension StorableValue where ValueToStore == Self {
    public func to() -> ValueToStore { return self }
    public static func from(_ v: ValueToStore) -> Self { return v }
}

extension String: StorableValue { }
extension Bool: StorableValue { }
extension Float: StorableValue { }
extension Double: StorableValue { }
extension Date: StorableValue { }
extension Data: StorableValue { }
extension Int: StorableValue { }
extension Int8: StorableValue { }
extension Int16: StorableValue { }
extension Int32: StorableValue { }
extension Int64: StorableValue { }
extension UInt: StorableValue { }
extension UInt8: StorableValue { }
extension UInt16: StorableValue { }
extension UInt32: StorableValue { }
extension UInt64: StorableValue { }
extension URL: StorableValue { }

extension Dictionary: StorableValue where Key == String, Value: StorableValue {
    public func to() -> [String: Value.ValueToStore] { mapValues { $0.to() } }
    public static func from(_ v: [String: Value.ValueToStore]) -> Self { v.mapValues(Value.from) }
}

extension StorableValue where Self: RawRepresentable, Self.RawValue: StorableValue {
    public func to() -> Self.RawValue.ValueToStore { rawValue.to() }
    public static func from(_ v: Self.RawValue.ValueToStore) -> Self { self.init(rawValue: Self.RawValue.from(v))! }
}

extension Optional: StorableValue where Wrapped: StorableValue {
    public func to() -> Wrapped.ValueToStore? { return self.map { $0.to() } }
    public static func from(_ v: Wrapped.ValueToStore?) -> Self { return v.map(Wrapped.from) }
}

extension Array: StorableValue where Element: StorableValue {
    public func to() -> [Element.ValueToStore] { map { $0.to() } }
    public static func from(_ v: [Element.ValueToStore]) -> Self { v.map(Element.from) }
}

extension Set: StorableValue where Element: StorableValue {
    public func to() -> [Element.ValueToStore] { map { $0.to() } }
    public static func from(_ v: [Element.ValueToStore]) -> Self { Self.init(v.map(Element.from)) }
}

public
protocol StorableCodableValue: Codable, StorableValue where ValueToStore == Data {
    static var encoder: AnyEncoder { get }
    static var decoder: AnyDecoder { get }
}

extension StorableCodableValue {
    static var encoder: AnyEncoder { JSONEncoder() }
    static var decoder: AnyDecoder { JSONDecoder() }

    public func to() -> Data { return try! self.encoded(using: Self.encoder) }
    public static func from(_ v: Data) -> Self { return try! v.decoded(using: Self.decoder) }
    
}
