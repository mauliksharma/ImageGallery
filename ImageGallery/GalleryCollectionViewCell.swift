//
//  GalleryCollectionViewCell.swift
//  ImageGallery
//
//  Created by Maulik Sharma on 19/10/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var imageURL: URL? {
        didSet {
            imageView?.image = nil
            imageError = false
            fetchImage()
        }
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView?.image = newValue
            activityIndicator?.stopAnimating()
            activityIndicator?.alpha = 0
        }
    }
    
    var imageError = false
    
    func fetchImage() {
        activityIndicator?.alpha = 1
        activityIndicator?.startAnimating()
        
        if let url = imageURL{
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.imageURL {
                        if let image = UIImage(data: imageData) {
                            self?.image = image
                        }
                        else {
                            self?.image = UIImage(named: "error.png")
                            self?.imageError = true
                        }
                    }
                }
            }
        }
    }
}
