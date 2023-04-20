//
//  CacheService.swift
//  Gallery
//
//  Created by Marek Baláž on 20/04/2023.
//

import Foundation

protocol CacheServiceProtocol {
    
}

protocol AlbumCacheServiceProtocol: CacheServiceProtocol {
    func saveAlbum(_ ans: Album)
    func loadAlbum() -> Album?
}

class AlbumCacheService: AlbumCacheServiceProtocol {
    
    static let shared: AlbumCacheService = AlbumCacheService()
    
    final let albumKey: String = "VJhYcoIvd9feXtWwCTisTzoXzuNDAYlA"
    
    init() { }
    
    func saveAlbum(_ ans: Album) {
        let userDefaults = UserDefaults.standard
        let encodedData = try! NSKeyedArchiver.archivedData(withRootObject: ans, requiringSecureCoding: false)
        userDefaults.set(encodedData, forKey: albumKey)
    }
    
    func loadAlbum() -> Album? {
        var album: Album?
        if let data = UserDefaults.standard.data(forKey: albumKey) {
            do {
                album = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Album
            }
            catch {
                Log.d("Could not load local data from cache.")
            }
        }
        return album
    }
    
}

