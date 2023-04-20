//
//  GalleryController.swift
//  Gallery
//
//  Created by Marek Baláž on 19/04/2023.
//

import UIKit

class GalleryController: UIViewController, GalleryCollectionViewModelDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var galleryCollectionView: GalleryCollectionView!

    // MARK: - Variables
    
    var updateTimer: Timer?
    
    // MARK: - Actions
    
    @objc func updateGalleryCollectionCellImage(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let indexPath = dict["index"] as? IndexPath {
                Log.d(indexPath)
                
                updateTimer?.invalidate()
                
                updateTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                    self?.galleryCollectionView.collectionGallery.reloadData()
                }
                
            }
        }
     }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Gallery"
        
        galleryCollectionView.galleryCollectionCellViewModel = GalleryCollectionCellViewModel()
        
        galleryCollectionView.galleryCollectionViewModel = GalleryCollectionViewModel()
        galleryCollectionView.galleryCollectionViewModel?.delegate = self
        galleryCollectionView.galleryCollectionViewModel?.getPhotos() // getAlbum(for: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateGalleryCollectionCellImage), name: .updateGalleryCollectionCell, object: nil)
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

