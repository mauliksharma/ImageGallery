//
//  GalleryDocumentTableViewController.swift
//  ImageGallery
//
//  Created by Maulik Sharma on 18/10/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit

class GalleryDocumentTableViewController: UITableViewController {
    
    var galleryDocuments = ["Untitled"]
    
    var recentlyDeletedDocuments = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Albums"
        }
        return "Recently Deleted"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return galleryDocuments.count
        }
        return recentlyDeletedDocuments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = galleryDocuments[indexPath.row]
        }
        else if indexPath.section == 1 {
            cell.textLabel?.text = recentlyDeletedDocuments[indexPath.row]
        }

        return cell
    }
    
    @IBAction func addGalleryDocument(_ sender: UIBarButtonItem) {
        galleryDocuments += ["Untitled".madeUnique(withRespectTo: galleryDocuments)]
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                let document = galleryDocuments.remove(at: indexPath.row)
                recentlyDeletedDocuments.insert(document, at: 0)
                tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 1))
            } else if indexPath.section == 1 {
                recentlyDeletedDocuments.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
//    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGallery" {
            if let galleryDocumentTVCell = sender as? UITableViewCell,
                let galleryCVC = (segue.destination as? UINavigationController)?.visibleViewController as? GalleryCollectionViewController {
                if let title = galleryDocumentTVCell.textLabel?.text {
                    galleryCVC.galleryName = title
                }
            }
        }
    }

}
