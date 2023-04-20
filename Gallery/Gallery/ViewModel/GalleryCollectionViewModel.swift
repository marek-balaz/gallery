//
//  GalleryCollectionViewModel.swift
//  Gallery
//
//  Created by Marek Baláž on 19/04/2023.
//

import Foundation

protocol GalleryCollectionViewModelDelegate: AnyObject {
    func didReceiveAlbumData()
    func shouldShowPhotoDetail()
}

class GalleryCollectionViewModel: GalleryViewModel {
    
    private let networkService: BaseAPIProtocol
    private let cacheService: AlbumCacheServiceProtocol
    weak var delegate: GalleryCollectionViewModelDelegate?
    var album: Album?
        
    init(networkService: BaseAPIProtocol = NetworkService(), cacheService: AlbumCacheService = AlbumCacheService()) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    func getPhotos() {
        networkService.getPhotos() { error, statusCode, data in
            if statusCode == 200 {
                
                if let json = data?.parseJSON() {
                    let album = Album(fromJson: json)
                    self.album = album
                    self.cacheService.saveAlbum(album)
                    self.fetchLocalImages(for: album)
                    self.delegate?.didReceiveAlbumData()
                } else {
                    Log.d("Request response data is empty.")
                    self.album = nil
                    self.delegate?.didReceiveAlbumData()
                }
                
            } else if (400..<500).contains(statusCode ?? -1) {
                Log.d(NetworkError.invalidResponse)
            } else {
                Log.d(NetworkError.apiError)
                self.album = self.cacheService.loadAlbum()
                self.fetchLocalImages(for: self.album)
                self.delegate?.didReceiveAlbumData()
            }
        }
    }
    
    func getAlbum(for id: Int) {
        networkService.getAlbum(albumId: id) { error, statusCode, data in
            if statusCode == 200 {
                
                if let json = data?.parseJSON() {
                    debugPrint(json)
                    let album = Album(fromJson: json)
                    self.album = album
                    self.fetchLocalImages(for: album)
                    self.delegate?.didReceiveAlbumData()
                } else {
                    Log.d("Request response data is empty.")
                    self.album = nil
                    self.delegate?.didReceiveAlbumData()
                }
                
            } else if (400..<500).contains(statusCode ?? -1) {
                Log.d(NetworkError.invalidResponse)
            } else {
                Log.d(NetworkError.apiError)
            }
        }
    }
    
    func fetchLocalImages(for album: Album?) {
        
        guard let album = album else {
            Log.d("Album doesn't exists.")
            return
        }
        
        guard let photos = album.photos else {
            Log.d("Album doesn't contain any photos.")
            return
        }
        
        for photo in photos {
            
            guard let thumbnailUrl = photo.thumbnailUrl else {
                Log.d("Thumbnail URL doesn't exist.")
                return
            }
            
            guard let photoName = getName(for: thumbnailUrl) else {
                return
            }
            
            guard let albumId = photo.albumId else {
                Log.d("AlbumId is nil")
                return
            }
            
            let folderName: String = "album_\(albumId)"
            
            if LocalFileService.shared.containsImage(imageName: photoName, folderName: folderName) {
                photo.thumbnail = LocalFileService.shared.getImage(imageName: photoName, folderName: folderName)
            }
            
        }
        
    }
    
    func numberOfPhotos() -> Int {
        
        guard let album = album else {
            return 0
        }
        
        guard let photos = album.photos else {
            Log.d("Album doesn't contain any photos.")
            return 0
        }
        
        return photos.count
    }
    
    func setSelectedPhoto(at index: Int) {
        
        guard let album = album else {
            Log.d("Album doesn't exists.")
            return
        }
        
        guard let photos = album.photos else {
            Log.d("Album doesn't contain any photos.")
            return
        }
        
        if index < photos.count {
            selectedPhoto = photos[index]
        } else {
            Log.d("Photo with index \(index) doesn't exist.")
        }
        
    }
    
}
