//
//  File.swift
//  File
//
//  Created by Antonio Cabezuelo Vivo on 14/8/21.
//

import Foundation


/// Protocol acting as a common API for all types of encoders,
/// such as `JSONEncoder` and `PropertyListEncoder`.
public protocol AnyEncoder {
    /// Encode a given value into binary data.
    func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONEncoder: AnyEncoder {}

#if canImport(ObjectiveC) || swift(>=5.1)
extension PropertyListEncoder: AnyEncoder {}
#endif

extension Encodable {
    /// Encode this value, optionally using a specific encoder.
    /// If no explicit encoder is passed, then the value is encoded into JSON.
    func encoded(using encoder: AnyEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}


// MARK: - Decoding

/// Protocol acting as a common API for all types of decoders,
/// such as `JSONDecoder` and `PropertyListDecoder`.
public protocol AnyDecoder {
    /// Decode a value of a given type from binary data.
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: AnyDecoder {}

#if canImport(ObjectiveC) || swift(>=5.1)
extension PropertyListDecoder: AnyDecoder {}
#endif

extension Data {
    /// Decode this data into a value, optionally using a specific decoder.
    /// If no explicit encoder is passed, then the data is decoded as JSON.
    func decoded<T: Decodable>(as type: T.Type = T.self,
                               using decoder: AnyDecoder = JSONDecoder()) throws -> T {
        return try decoder.decode(T.self, from: self)
    }
}
