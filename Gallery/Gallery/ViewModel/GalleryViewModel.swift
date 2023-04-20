//
//  GalleryViewModel.swift
//  Gallery
//
//  Created by Marek Baláž on 20/04/2023.
//

import Foundation

class GalleryViewModel {
    
    var selectedPhoto: Photo?
    
    func getName(for photoUrl: String?) -> String? {
        
        guard let photoUrl else {
            Log.d("Photo URL is empty.")
            return nil
        }
        
        if let url = URL(string: photoUrl) {
            let lastPathComponent = url.lastPathComponent
            return lastPathComponent
        }
        
        return nil
    }
    
    func getSelectedPhoto() -> Photo? {
        guard let selectedPhoto else {
            Log.d("Selected photo is nil.")
            return nil
        }
        return selectedPhoto
    }
    
}
