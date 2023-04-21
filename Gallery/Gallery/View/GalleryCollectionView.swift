//
//  GalleryCollectionView.swift
//  Gallery
//
//  Created by Marek Baláž on 19/04/2023.
//

import UIKit

class GalleryCollectionView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var componentContentView : UIView!
    @IBOutlet weak var collectionGallery    : UICollectionView!
    
    // MARK: - Constants
    
    internal let INSET: CGFloat = 3
    
    // MARK: - Variables
    
    public var galleryCollectionViewModel: GalleryCollectionViewModel?
    public var galleryCollectionCellViewModel: GalleryCollectionCellViewModel?
    
    internal var reuseIdentifier: String = "GalleryCollectionViewCell"
    
    // MARK: - Overrides
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    private func setupXib() {
        let view = loadXib()
        view?.frame = self.bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(componentContentView)
        componentContentView = view
    }
    
    private func loadXib() -> UIView? {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        
        collectionGallery.delegate = self
        collectionGallery.dataSource = self
        collectionGallery.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        return componentContentView
    }
    
}

// MARK: - Collection

extension GalleryCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = galleryCollectionViewModel?.numberOfPhotos() else {
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? GalleryCollectionViewCell else {
            Log.d("Cell has incorrect reuseIdentifier.")
            return UICollectionViewCell()
        }
        if let photo = galleryCollectionViewModel?.album?.photos?[indexPath.row] {
            cell.set(model: galleryCollectionCellViewModel, photo: photo)
            cell.galleryCollectionCellViewModel?.set(photo: photo)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        galleryCollectionViewModel?.setSelectedPhoto(at: indexPath.row)
        galleryCollectionViewModel?.delegate?.shouldShowPhotoDetail()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: INSET, left: INSET, bottom: INSET, right: INSET)
            layout.minimumInteritemSpacing = INSET
            layout.minimumLineSpacing = INSET
        }

        return CGSize(width: (self.bounds.width - 4*INSET) / 3, height: (self.bounds.width - 4*INSET) / 3)
    }
    
}
