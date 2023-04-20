//
//  PhotoDetailViewModel.swift
//  Gallery
//
//  Created by Marek Baláž on 20/04/2023.
//

import Foundation

protocol PhotoDetailViewModelDelegate: AnyObject {
    func didReceiveDetailImageData(photo: Photo)
    func shouldShowLoading()
    func shouldHideLoading()
}

class PhotoDetailViewModel: GalleryViewModel {
    
    private let networkService: NetworkServiceProtocol
    weak var delegate: PhotoDetailViewModelDelegate?
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func set(photo: Photo) {
        
        guard let photoUrl = photo.url else {
            Log.d("Photo URL doesn't exist.")
            return
        }
        
        guard let photoName = getName(for: photoUrl) else {
            Log.d("Photo doesn't have name.")
            return
        }
        
        guard let albumId = photo.albumId else {
            Log.d("AlbumId is nil")
            return
        }
        
        let folderName: String = "album_\(albumId)_details"
        
        if photo.image != nil {
            delegate?.didReceiveDetailImageData(photo: photo)
        } else if LocalFileService.shared.containsImage(imageName: photoName, folderName: folderName) {
            photo.image = LocalFileService.shared.getImage(imageName: photoName, folderName: folderName)
            delegate?.didReceiveDetailImageData(photo: photo)
        } else {
            
            guard let url = URL(string: photoUrl) else {
                Log.d("Could not create URL for photo.")
                return
            }
            
            self.delegate?.shouldShowLoading()
            NetworkService.shared.download(from: url) { [weak self] error, statusCode, data in
                if statusCode == 200 {
                    
                    if let data, let image = LocalFileService.shared.dataToImage(for: data) {
                        photo.image = image
                        LocalFileService.shared.saveImage(image: image, imageName: photoName, folderName: folderName)
                    } else {
                        Log.d("No image data.")
                    }
                    
                    self?.delegate?.didReceiveDetailImageData(photo: photo)
                    
                } else if (400..<500).contains(statusCode ?? -1) {
                    Log.d(NetworkError.invalidResponse)
                } else {
                    Log.d(NetworkError.apiError)
                }
                self?.delegate?.shouldHideLoading()
            }
        }
    }
    
    func shouldShowThumbnail(for photo: Photo?) -> Bool {
        
        guard let selectedPhoto = photo else {
            Log.d("Selected photo doesn't exist.")
            return false
        }
        
        return selectedPhoto.thumbnail != nil && selectedPhoto.image == nil
    }
    
}
