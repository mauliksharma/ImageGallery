//
//  ImageGallery.swift
//  ImageGallery
//
//  Created by Maulik Sharma on 26/10/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import Foundation

struct ImageGallery: Codable {
    
    var infoForImages = [ImageInfo]()
    
    struct ImageInfo: Codable {
        var aspectRatio = Float(1.0)
        var url = URL(string: "")
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data){
        if let newValue = try? JSONDecoder().decode(ImageGallery.self, from: json) {
            self = newValue
        }
        else {
            return nil
        }
    }
    
    init(infoForImages: [ImageInfo]) {
        self.infoForImages = infoForImages
    }
    
}
