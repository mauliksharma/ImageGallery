//
//  GalleryCollectionViewController.swift
//  ImageGallery
//
//  Created by Maulik Sharma on 18/10/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit

class GalleryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDropDelegate {
    
    var images = [Image]()
    var scaleFactor: CGFloat = 1.0
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        if let imageCell = cell as? GalleryCollectionViewCell {
            imageCell.imageURL = images[indexPath.item].url
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(300)
        return CGSize(width: width, height: width / CGFloat(images[indexPath.item].aspectRatio))
    }
    
    // MARK: - UICollectionViewDragDelegate
    
    
    
    // MARK: UICollectionViewDropDelegate
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(row: 0, section: 0)
        for item in coordinator.items {
            let placeholderContext = coordinator.drop(item.dragItem,
                                                      to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "PlaceholderCell"))
            var newImage = Image()
            
            item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                DispatchQueue.main.async {
                    if let image = provider as? UIImage {
                        newImage.aspectRatio = image.size.width / image.size.height
                    }
                }
            }
            item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                DispatchQueue.main.async {
                    if let url = provider as? URL {
                        newImage.url = url.imageURL
                        placeholderContext.commitInsertion(dataSourceUpdates: { (insertionIndexPath) in
                            self.images.insert(newImage, at: insertionIndexPath.item)
                        })
                    } else {
                        placeholderContext.deletePlaceholder()
                    }
                }
            }
        }
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
        override func viewDidLoad() {
            super.viewDidLoad()
//            collectionView?.dragDelegate = self
            collectionView?.dropDelegate = self
        }

}

struct Image {
    var aspectRatio = CGFloat(1.0)
    var url = URL(string: "")
}
