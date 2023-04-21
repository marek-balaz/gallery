//
//  Photo.swift
//  Gallery
//
//  Created by Marek Baláž on 19/04/2023.
//

import Foundation
import UIKit

class Photo: NSObject, NSCoding {
    
    var albumId: Int?
    var id: Int?
    var title: String?
    var url: String?
    var thumbnailUrl: String?
    var thumbnail: UIImage?
    var image: UIImage?
    var isLoading: Bool = false
    
    init(fromJson: [String: Any]) {
    
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
    
    func encode(with coder: NSCoder) {
        coder.encode(albumId, forKey: "albumId")
        coder.encode(id, forKey: "id")
        coder.encode(title, forKey: "title")
        coder.encode(url, forKey: "url")
        coder.encode(thumbnailUrl, forKey: "thumbnailUrl")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.albumId = aDecoder.decodeObject(forKey: "albumId") as? Int
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.url = aDecoder.decodeObject(forKey: "url") as? String
        self.thumbnailUrl = aDecoder.decodeObject(forKey: "thumbnailUrl") as? String
    }
}
