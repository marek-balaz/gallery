//
//  GalleryCollectionCellViewModel.swift
//  Gallery
//
//  Created by Marek Baláž on 20/04/2023.
//

import Foundation

protocol GalleryCollectionCellViewModelDelegate: AnyObject {
    func didReceiveImageData(photo: Photo, laterUpdate: Bool)
}

class GalleryCollectionCellViewModel: GalleryViewModel {
    
    private let networkService: BaseAPIProtocol
    weak var delegate: GalleryCollectionCellViewModelDelegate?
    
    init(networkService: BaseAPIProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func set(photo: Photo) {
        
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
        
        if photo.thumbnail != nil {
            delegate?.didReceiveImageData(photo: photo, laterUpdate: false)
        } else if LocalFileService.shared.containsImage(imageName: photoName, folderName: folderName) {
            photo.thumbnail = LocalFileService.shared.getImage(imageName: photoName, folderName: folderName)
            delegate?.didReceiveImageData(photo: photo, laterUpdate: false)
        } else {
            
            guard let url = URL(string: thumbnailUrl) else {
                Log.d("Could not create URL for thumbnail.")
                return
            }
           
            NetworkService.shared.download(from: url) { error, statusCode, data in
                if statusCode == 200 {
                    
                    if let data, let image = LocalFileService.shared.dataToImage(for: data) {
                        photo.thumbnail = image
                        LocalFileService.shared.saveImage(image: image, imageName: photoName, folderName: folderName)
                    } else {
                        Log.d("No image data.")
                    }
                    
                    self.delegate?.didReceiveImageData(photo: photo, laterUpdate: true)
                    
                } else if (400..<500).contains(statusCode ?? -1) {
                    Log.d(NetworkError.invalidResponse)
                } else {
                    Log.d(NetworkError.apiError)
                }
            }
            
        }
    }
    
    
    
}
