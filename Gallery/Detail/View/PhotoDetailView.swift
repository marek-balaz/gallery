//
//  PhotoDetailView.swift
//  Gallery
//
//  Created by Marek Baláž on 20/04/2023.
//

import Foundation
import UIKit

class PhotoDetailView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var componentContentView: UIView!
    
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
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
        
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = true
        
        return componentContentView
    }
    
}
