//
//  GalleryCollectionViewCell.swift
//  Gallery
//
//  Created by Marek Baláž on 19/04/2023.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell, GalleryCollectionCellViewModelDelegate {

    @IBOutlet weak var thumbnailImg: UIImageView!
    
    var galleryCollectionCellViewModel: GalleryCollectionCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(model: GalleryCollectionCellViewModel?) {
        galleryCollectionCellViewModel = model
        model?.delegate = self
    }
    
    func didReceiveImageData(photo: Photo, laterUpdate: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.thumbnailImg.image = photo.thumbnail
            if laterUpdate {
                NotificationCenter.default.post(name: .updateGalleryCollectionCell, object: nil, userInfo: nil)
            }
        }
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImg.image = UIImage(named: "placeholder-image")
    }
    
}
