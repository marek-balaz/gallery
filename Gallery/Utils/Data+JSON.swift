//
//  Data+JSON.swift
//  Gallery
//
//  Created by Marek Baláž on 20/04/2023.
//

import Foundation

extension Data {
    
    func parseJSON() -> [String: Any]? {
        
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: [])
            if let dictionary = json as? [String: Any] {
                return dictionary
            } else if let array = json as? [Any] {
                return ["root_array": array]
            } else {
                Log.d("Failed to parse JSON data.")
                return nil
            }
        } catch {
            Log.d("Failed to parse JSON data: \(error.localizedDescription)")
            return nil
        }
    }
}
