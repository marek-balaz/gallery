//
//  PhotoDetailController.swift
//  Gallery
//
//  Created by Marek Baláž on 20/04/2023.
//

import Foundation
import UIKit

class PhotoDetailController: UIViewController, PhotoDetailViewModelDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var photoDetailView: PhotoDetailView!
    
    // MARK: - Variables
    
    var photoDetailViewModel: PhotoDetailViewModel?
    var photo: Photo?
    
    // MARK: - Actions
    
    @objc func closeBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoDetailViewModel = PhotoDetailViewModel()
        photoDetailViewModel?.delegate = self
        guard let photo else {
            Log.d("Photo not available.")
            return
        }
        photoDetailViewModel?.set(photo: photo)
        
        if photoDetailViewModel?.shouldShowThumbnail(for: photo) ?? false {
            photoDetailView.photoImg.image = photo.thumbnail
        }
        
        photoDetailView.closeBtn.addTarget(self, action: #selector(closeBtnAction(_:)), for: .touchUpInside)
    }
    
    // MARK: - Delegates
    
    func didReceiveDetailImageData(photo: Photo) {
        DispatchQueue.main.async { [weak self] in
            self?.photoDetailView.photoImg.image = photo.image
        }
    }
    
    func shouldShowLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.photoDetailView.loadingIndicator.isHidden = false
        }
    }
    
    func shouldHideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.photoDetailView.loadingIndicator.isHidden = true
        }
    }
    
    // MARK: - Implementation
    
    // MARK: - Navigation
    
}
