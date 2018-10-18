//
//  ImageFullViewController.swift
//  ImageGallery
//
//  Created by Maulik Sharma on 18/10/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit

class ImageFullViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var image = UIImage()
    
    var imageView = UIImageView()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
