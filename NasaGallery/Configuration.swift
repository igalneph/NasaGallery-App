//
//  Configuration.swift
//  NasaGallery
//
//  Created by Igal on 14/08/2025.
//

import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey
        case invalidValue
    }
    
    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        // Try to get the value from Info.plist
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }
        
        switch object {
        // If the value is already of the correct type
        case let value as T:
            return value
            
        // If it's a String, try to convert it to the desired type
        case let string as String:
            guard let value = T(string) else {
                fallthrough
            }
            return value
            
        // If it doesn't match the expected type or can't be converted
        default:
            throw Error.invalidValue
        }
    }
}
