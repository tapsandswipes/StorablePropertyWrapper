//
//  StorablePropertyWrapper.swift
//
//  Copyright © 2020 Antonio Cabezuelo Vivo. All rights reserved.
//

import Foundation


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
            DispatchQueue.main.async { [self] in
                NotificationCenter.default.post(name: didChangeNotification, object: self)
            }
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
            store.registerDefault(value.to(), forKey: key)
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
