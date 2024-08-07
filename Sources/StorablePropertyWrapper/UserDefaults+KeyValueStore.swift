//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 27/3/21.
//

import Foundation

extension UserDefaults: KeyStore {
    public static let willChangeNotification: NSNotification.Name = NSNotification.Name("NSUserDefaultsWillChangeNotification")
    
    public
    func set<T>(_ value: T, forKey key: String) {
        NotificationCenter.default.post(name: UserDefaults.willChangeNotification, object: self, userInfo: nil)
        if let optional = value as? AnyOptional, optional.isNil {
            removeObject(forKey: key)
        } else {
            if T.self == URL.self {
                self.set(value as? URL, forKey: key)
            } else if T.self == Optional<URL>.self, let v = value as? URL {
                self.set(v as URL?, forKey: key)
            } else {
                self.set(value as Any?, forKey: key)
            }
        }
    }
    
    public
    func get<T>(_ key: String) -> T? {
        if T.self == URL.self {
            return url(forKey: key) as! T?
        } else if T.self == Optional<URL>.self {
            return url(forKey: key) as! T?
        } else {
            return object(forKey: key) as? T
        }
    }
    
    public
    func remove(_ key: String) {
        NotificationCenter.default.post(name: UserDefaults.willChangeNotification, object: self, userInfo: nil)
        removeObject(forKey: key)
    }
    
}

#if compiler(>=5.8) && hasFeature(RetroactiveAttribute)
extension UserDefaults: @retroactive @unchecked Sendable {}
#else
extension UserDefaults: @unchecked Sendable {}
#endif

extension UserDefaults: SupportsDefaultValues {
    public
    func registerDefault<T>(_ value: T, forKey key: String) {
        if let optional = value as? AnyOptional, optional.isNil {
            // no-op
        } else {
            register(defaults: [key: value as Any])
        }
    }
}

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}
