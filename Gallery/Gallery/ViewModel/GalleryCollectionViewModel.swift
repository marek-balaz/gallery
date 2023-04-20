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
    weak var delegate: GalleryCollectionViewModelDelegate?
    var album: Album?
        
    init(networkService: BaseAPIProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func getPhotos() {
        networkService.getPhotos() { error, statusCode, data in
            if statusCode == 200 {
                
                if let json = data?.parseJSON() {
                    let album = Album(fromJson: json)
                    self.album = album
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
    
    func getAlbum(for id: Int) {
        networkService.getAlbum(albumId: id) { error, statusCode, data in
            if statusCode == 200 {
                
                if let json = data?.parseJSON() {
                    debugPrint(json)
                    let album = Album(fromJson: json)
                    self.album = album
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
    
    func loadImageForPhoto() {
        
        guard let album = album else {
            Log.d("Album doesn't exists.")
            return
        }
        
        guard let photos = album.photos else {
            Log.d("Album doesn't contain any photos.")
            return
        }
        
        
        
    }
    
    func numberOfPhotos() -> Int {
        
        guard let album = album else {
            Log.d("Album doesn't exists.")
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
