//
//  Dictionary+AddKey.swift
//  Gallery
//
//  Created by Marek Baláž on 20/04/2023.
//

import Foundation

extension Dictionary {
    
    mutating func addJsonItem<T>(_ key: String, _ value: T?) {
        if let value = value {
            self[key as! Key] = value as? Value
        }
    }

}
