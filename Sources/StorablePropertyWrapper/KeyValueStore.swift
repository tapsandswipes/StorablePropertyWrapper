//
//  KeyValueStore.swift
//
//  Copyright © 2020 Antonio Cabezuelo Vivo. All rights reserved.
//

import Foundation


public
protocol KeyStore {
    func set<T>(_ value: T, forKey key: String)
    func get<T>(_ key: String) -> T?
    func remove(_ key: String)
}

extension UserDefaults: KeyStore {
    public static let willChangeNotification: NSNotification.Name = NSNotification.Name("NSUserDefaultsWillChangeNotification")

    public
    func set<T>(_ value: T, forKey key: String) {
        NotificationCenter.default.post(name: UserDefaults.willChangeNotification, object: self, userInfo: nil)
        if let optional = value as? AnyOptional, optional.isNil {
            removeObject(forKey: key)
        } else {
            self.set(value as Any?, forKey: key)
        }
    }
    
    public
    func get<T>(_ key: String) -> T? {
        return object(forKey: key) as? T
    }
    
    public
    func remove(_ key: String) {
        NotificationCenter.default.post(name: UserDefaults.willChangeNotification, object: self, userInfo: nil)
        removeObject(forKey: key)
    }
}


private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}
