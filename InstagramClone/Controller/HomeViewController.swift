//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Mihai Ruber on 2/24/18.
//  Copyright © 2018 Mihai Ruber. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UICollectionViewController {

    // Variables
    var refresher: UIRefreshControl!
    var page: Int = 10
    var uuidArray = [String]()
    var picArray = [PFFile]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up view
        collectionView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationItem.title = PFUser.current()?.username?.uppercased()
        
        // pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(HomeViewController.refresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        
        // load posts function
        loadPosts()
        
        // receive notification of a post
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.uploaded(notification:)), name: NSNotification.Name(rawValue: "uploaded"), object: nil)

    }
    
    @objc func uploaded(notification: NSNotification) {
        loadPosts()
    }
    
    // refresh
    @objc func refresh() {
        collectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    // load posts
    func loadPosts() {
        let query = PFQuery(className: "posts")
        query.addDescendingOrder("createdAt")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        query.limit = page
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                // clearn up
                self.uuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.uuidArray.append(object.value(forKeyPath: "uuid") as! String)
                    self.picArray.append(object.value(forKeyPath: "pic") as! PFFile)
                }
                
                self.collectionView?.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderView
    
            // Setup the header view
            header.fullNameLbl.text = (PFUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
            header.webTxt.text = (PFUser.current()?.object(forKey: "web") as? String)
            header.webTxt.sizeToFit()
            header.bioLbl.text = (PFUser.current()?.object(forKey: "bio") as? String)
            header.bioLbl.sizeToFit()
            header.button.setTitle("edit profile", for: UIControlState.normal)
        
            let profImageQuery = PFUser.current()?.object(forKey: "profImg") as! PFFile
            profImageQuery.getDataInBackground { (data: Data?, error: Error?) in
            header.profImage.image = UIImage(data: data!)
        }
        return header
    }


//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//
    
    // cell config
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! PictureCell
        // Get pic from picArray
        picArray[indexPath.row].getDataInBackground { (data: Data?, error: Error?) in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            } else {
                print(error?.localizedDescription)
            }
        }
        return cell
        
    }
    
    // number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return picArray.count
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

}
