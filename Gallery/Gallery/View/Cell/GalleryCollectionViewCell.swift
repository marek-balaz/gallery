//
//  GalleryCollectionViewCell.swift
//  Gallery
//
//  Created by Marek Baláž on 19/04/2023.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImg: UIImageView!
    
    var galleryCollectionCellViewModel: GalleryCollectionCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(model: GalleryCollectionCellViewModel?, photo: Photo) {
        galleryCollectionCellViewModel = model
        self.thumbnailImg.image = photo.thumbnail ?? UIImage(named: "placeholder-image")
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImg.image = UIImage(named: "placeholder-image")
    }
    
}
