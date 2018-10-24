//
//  ImageFullViewController.swift
//  ImageGallery
//
//  Created by Maulik Sharma on 18/10/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit

class ImageFullViewController: UIViewController, UIScrollViewDelegate {
    
    var image = UIImage() {
        didSet {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
        }
    }
    
    var imageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.addSubview(imageView)
            scrollView.contentSize = imageView.frame.size
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 5.0
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewDidLayoutSubviews() {
        let currentScale = scrollView.zoomScale
        scrollView.setZoomScale(1, animated: false)
        imageView.frame = scrollView.bounds
        scrollView.contentSize = imageView.frame.size
        scrollView.setZoomScale(currentScale, animated: false)
    }
    
}
