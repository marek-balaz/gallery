//
//  Album.swift
//  Gallery
//
//  Created by Marek Baláž on 20/04/2023.
//

import Foundation

class Album: BaseModel {
    
    var photos: [Photo]?
    
    override init(fromJson: [String : Any]) {
        super.init(fromJson: fromJson)
        
        let array = fromJson["root_array"] as? [[String: AnyObject]]
        if let array {
            self.photos = []
            for element in array {
                self.photos?.append(Photo(fromJson: element))
            }
        }
    }
    
}
