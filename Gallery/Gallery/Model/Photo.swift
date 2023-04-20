//
//  Photo.swift
//  Gallery
//
//  Created by Marek Baláž on 19/04/2023.
//

import Foundation
import UIKit

class Photo: BaseModel {
    
    var albumId: Int?
    var id: Int?
    var title: String?
    var url: String?
    var thumbnailUrl: String?
    var thumbnail: UIImage?
    var image: UIImage?
    
    override init(fromJson: [String: Any]) {
        super.init(fromJson: fromJson)
        
        albumId = fromJson["albumId"] as? Int
        id = fromJson["id"] as? Int
        title = fromJson["title"] as? String
        url = fromJson["url"] as? String
        thumbnailUrl = fromJson["thumbnailUrl"] as? String

    }
    
    func getJson() -> [String: AnyObject] {
        
        var dic = [String: AnyObject]()
        dic.addJsonItem("albumId", albumId)
        dic.addJsonItem("id", id)
        dic.addJsonItem("title", title)
        dic.addJsonItem("url", url)
        dic.addJsonItem("thumbnailUrl", thumbnailUrl)
        
        return dic
    }
    
}
