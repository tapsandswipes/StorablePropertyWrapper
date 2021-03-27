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

public
protocol SupportsDefaultValues {
    func registerDefault<T>(_ value: T, forKey key: String)
}
