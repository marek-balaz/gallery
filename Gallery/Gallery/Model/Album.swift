//
//  Album.swift
//  Gallery
//
//  Created by Marek Baláž on 20/04/2023.
//

import Foundation

class Album: NSObject, NSCoding {
    
    var photos: [Photo]?
    
    init(fromJson: [String : Any]) {
        
        let array = fromJson["root_array"] as? [[String: AnyObject]]
        if let array {
            self.photos = []
            for element in array {
                self.photos?.append(Photo(fromJson: element))
            }
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(photos, forKey: "root_array")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.photos = aDecoder.decodeObject(forKey: "root_array") as? [Photo]
    }
    
}
