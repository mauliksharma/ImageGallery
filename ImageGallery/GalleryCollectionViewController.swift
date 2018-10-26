//
//  GalleryCollectionViewController.swift
//  ImageGallery
//
//  Created by Maulik Sharma on 18/10/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit

class GalleryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    var imageGallery: ImageGallery?
    
    var infoForImages = [ImageGallery.ImageInfo]()
    
    var scaleFactor: CGFloat = 1.0
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoForImages.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if infoForImages.indices.contains(indexPath.item) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
            if let imageCell = cell as? GalleryCollectionViewCell {
                imageCell.imageURL = infoForImages[indexPath.item].url
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceholderCell", for: indexPath)
            return cell
        }
        
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    var flowLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    var itemWidth: CGFloat {
        return collectionView.bounds.width - 50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if infoForImages.indices.contains(indexPath.item) {
            let width = scaleFactor * itemWidth
            return CGSize(width: width, height: width / CGFloat(infoForImages[indexPath.item].aspectRatio))
        }
        return CGSize(width: itemWidth, height: 0)
    }
    
    // MARK: - UICollectionViewDragDelegate
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let galleryCell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell {
            if let imageData = galleryCell.image {
                let dragItem = UIDragItem(itemProvider: NSItemProvider(object: imageData))
                return [dragItem]
            }
        }
        return []
    }
    
    // MARK: UICollectionViewDropDelegate
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return isSelf ? session.canLoadObjects(ofClass: UIImage.self) : session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: infoForImages.count, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                collectionView.performBatchUpdates({
                    let imageInfo = infoForImages.remove(at: sourceIndexPath.item)
                    infoForImages.insert(imageInfo, at: destinationIndexPath.item)
                    collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
            else {
                var newImage = ImageGallery.ImageInfo()
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let image = provider as? UIImage {
                            newImage.aspectRatio = Float(image.aspectRatio)
                        }
                    }
                }
                let placeholderContext = coordinator.drop(item.dragItem,
                                                          to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "PlaceholderCell"))
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let url = provider as? URL {
                            newImage.url = url.imageURL
                            placeholderContext.commitInsertion(dataSourceUpdates: { (insertionIndexPath) in
                                self.infoForImages.insert(newImage, at: insertionIndexPath.item)
                            })
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showFullView" {
            if let galleryCVC = sender as? GalleryCollectionViewCell {
                return !galleryCVC.imageError
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFullView" {
            if let galleryCVC = sender as? GalleryCollectionViewCell, let fullVC = segue.destination as? ImageFullViewController {
                if let image = galleryCVC.image {
                    fullVC.image = image
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        flowLayout?.minimumInteritemSpacing = 10
        collectionView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(changeScale(_:))))
    }
    
    @objc func changeScale(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            scaleFactor = max(min(scaleFactor * recognizer.scale, 1.0), 0.2)
            flowLayout?.invalidateLayout()
            recognizer.scale = 1
        default:
            return
        }
    }
    
}


