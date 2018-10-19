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
    
    var imageLink: URL? {
        didSet {
            fetchImage()
        }
    }
    
    var imageData: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }
    
    func fetchImage() {
        if let url = imageLink{
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.imageLink {
                        self?.imageData = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
}
