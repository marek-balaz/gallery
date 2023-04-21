//
//  GalleryController.swift
//  Gallery
//
//  Created by Marek Baláž on 19/04/2023.
//

import UIKit

class GalleryController: UIViewController, GalleryCollectionViewModelDelegate, GalleryCollectionCellViewModelDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var galleryCollectionView: GalleryCollectionView!

    // MARK: - Variables
    
    var updateTimer: Timer?
    
    // MARK: - Actions
    
    @objc func updateGalleryCollectionCellImage() {
        updateTimer?.invalidate()
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.galleryCollectionView.collectionGallery.reloadData()
        }
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Gallery"
        
        galleryCollectionView.galleryCollectionCellViewModel = GalleryCollectionCellViewModel(downloadQueue: DispatchQueue(label: "com.balaz.gallery", qos: .userInitiated, attributes: .concurrent))
        
        galleryCollectionView.galleryCollectionCellViewModel?.delegate = self
        
        galleryCollectionView.galleryCollectionViewModel = GalleryCollectionViewModel()
        galleryCollectionView.galleryCollectionViewModel?.delegate = self
        
        galleryCollectionView.galleryCollectionViewModel?.getPhotos() // getAlbum(for: 1)
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Delegates
    
    func didReceiveAlbumData() {
        DispatchQueue.main.async { [weak self] in
            self?.galleryCollectionView.collectionGallery.reloadData()
        }
    }
    
    func didReceiveImageData() {
        DispatchQueue.main.async { [weak self] in
            self?.galleryCollectionView.collectionGallery.reloadData()
        }
    }
    
    func shouldShowPhotoDetail() {
        self.performSegue(withIdentifier: "showPhotoDetail", sender: nil)
    }
    
    // MARK: - Implementation
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotoDetail" {
            if let vc = segue.destination as? PhotoDetailController {
                vc.photo = self.galleryCollectionView.galleryCollectionViewModel?.getSelectedPhoto()
            } else {
                Log.d("Destination VC is not type of PhotoDetailController")
            }
        }
    }
    
}

