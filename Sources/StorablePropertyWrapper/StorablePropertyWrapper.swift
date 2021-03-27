//
//  StorablePropertyWrapper.swift
//
//  Copyright © 2020 Antonio Cabezuelo Vivo. All rights reserved.
//

import Foundation
import Codextended

@propertyWrapper public
struct Storable<T: StorableValue> {
    public let `default`: T
    private let key: String
    private let store: KeyStore
    
    public
    let willChangeNotification: Notification.Name
    public
    let didChangeNotification: Notification.Name

    public
    var wrappedValue: T {
        get { return store.get(key).map(T.from) ?? self.default }
        set {
            NotificationCenter.default.post(name: willChangeNotification, object: self)
            store.set(newValue.to(), forKey: key)
            NotificationCenter.default.post(name: didChangeNotification, object: self)
        }
    }
    
    public
    var projectedValue: Storable<T> {
        return self
    }
    
    public
    init(key: String, default value: T, store: KeyStore = UserDefaults.standard, notificationsPrefix: String = "") {
        self.key = key
        self.default = value
        self.store = store
        self.willChangeNotification = Notification.Name(notificationsPrefix + key.capitalizingFirstLetter() + "WillChange")
        self.didChangeNotification = Notification.Name(notificationsPrefix + key.capitalizingFirstLetter() + "DidChange")
        if let store = store as? SupportsDefaultValues {
            store.registerDefault(value, forKey: key)
        }
    }
    
    public
    func remove() {
        NotificationCenter.default.post(name: willChangeNotification, object: self)
        store.remove(key)
        NotificationCenter.default.post(name: didChangeNotification, object: self)
    }
    
}

/// For testing purposes
extension Storable {
    /// Get the value directly from the store without going through the wrappedValue
    func storedValue() -> Any? {
        guard let v: T.ValueToStore = store.get(key) else { return nil }
        
        // The forced cast is needed to avoid wrapping v inside another Optional
        return v as! Any?
    }
}

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
extension Dictionary: StorableValue where Key: StorableValue, Key.ValueToStore == Key, Value: StorableValue, Value.ValueToStore == Value {}

extension StorableValue where Self: RawRepresentable, Self.RawValue: StorableValue {
    public func to() -> Self.RawValue.ValueToStore { rawValue.to() }
    public static func from(_ v: Self.RawValue.ValueToStore) -> Self { self.init(rawValue: Self.RawValue.from(v))! }
}

extension Optional: StorableValue where Wrapped: StorableValue {
    public func to() -> Wrapped.ValueToStore? { return self.map({ $0.to() }) }
    public static func from(_ v: Wrapped.ValueToStore?) -> Self { return v.map(Wrapped.from) }
}

extension Array: StorableValue where Element: StorableValue {
    public func to() -> [Element.ValueToStore] { map({$0.to()}) }
    public static func from(_ v: [Element.ValueToStore]) -> Self { v.map(Element.from) }
}


public
protocol StorableCodableValue: Codable, StorableValue where ValueToStore == Data { }

extension StorableCodableValue {
    public func to() -> Data { return try! self.encoded() }
    public static func from(_ v: Data) -> Self { return try! v.decoded() }

}
