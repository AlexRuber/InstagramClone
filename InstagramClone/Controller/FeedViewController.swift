//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by Mihai Ruber on 2/25/18.
//  Copyright © 2018 Mihai Ruber. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UITableViewController {

    // Outlets
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var refresher = UIRefreshControl()
    
    
    // arrays hold server data
    var usernameArray = [String]()
    var profImageArray = [PFFile]()
    var dateArray = [NSDate?]()
    var picArray = [PFFile]()
    var titleArray = [String]()
    var uuidArray = [String]()
    
    var page: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Feed"
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 520
        
        // center indictor
        indicator.center.x = tableView.center.x
        
        
        //pull to refresh
        refresher.addTarget(self, action: #selector(FeedViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        // receive notification of a post
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.uploaded(notification:)), name: NSNotification.Name(rawValue: "uploaded"), object: nil)
        
        //calling function to load posts
        loadPosts()
        
    }
    
    // refresh
    @objc func refresh() {
        tableView?.reloadData()
        refresher.endRefreshing()
    }
    
    
    @objc func uploaded(notification: NSNotification) {
        loadPosts()
    }
    
    // load posts
    func loadPosts() {
        
        let postQuery = PFQuery(className: "posts")
        postQuery.limit = page
        postQuery.addDescendingOrder("createdAt")
        postQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                // clean up
                self.usernameArray.removeAll(keepingCapacity: false)
                self.profImageArray.removeAll(keepingCapacity: false)
                self.dateArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                self.titleArray.removeAll(keepingCapacity: false)
                self.uuidArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.usernameArray.append(object.object(forKey: "username") as! String)
                    self.profImageArray.append(object.object(forKey: "profImg") as! PFFile)
                    self.dateArray.append(object.createdAt as! NSDate)
                    self.picArray.append(object.object(forKey: "pic") as! PFFile)
                    self.titleArray.append(object.object(forKey: "title") as! String)
                    self.uuidArray.append(object.object(forKey: "uuid") as! String)
                }
                
                self.tableView.reloadData()
                self.refresher.endRefreshing()
                
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height * 2 {
            loadMore()
        }
    }

    func loadMore() {
        
        
        // if posts are more than shown
        if page <= uuidArray.count {
            indicator.startAnimating()
            page = page + 10
            
            let postQuery = PFQuery(className: "posts")
            postQuery.limit = page
            postQuery.addDescendingOrder("createdAt")
            postQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    
                    // clean up
                    self.usernameArray.removeAll(keepingCapacity: false)
                    self.profImageArray.removeAll(keepingCapacity: false)
                    self.dateArray.removeAll(keepingCapacity: false)
                    self.picArray.removeAll(keepingCapacity: false)
                    self.titleArray.removeAll(keepingCapacity: false)
                    self.uuidArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        self.usernameArray.append(object.object(forKey: "username") as! String)
                        self.profImageArray.append(object.object(forKey: "profImg") as! PFFile)
                        self.dateArray.append(object.createdAt as! NSDate)
                        self.picArray.append(object.object(forKey: "pic") as! PFFile)
                        self.titleArray.append(object.object(forKey: "title") as! String)
                        self.uuidArray.append(object.object(forKey: "uuid") as! String)
                    }
                    
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                    
                } else {
                    print(error?.localizedDescription)
                }
            }
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostCell
        
        // connect objects to cell
        cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: UIControlState.normal)
        cell.usernameBtn.sizeToFit()
        cell.titleLbl.text = titleArray[indexPath.row]
        cell.titleLbl.sizeToFit()
        
        //prof pic
        profImageArray[indexPath.row].getDataInBackground { (data: Data?, error: Error?) in
            cell.profImg.image = UIImage(data: data!)
        }
        
        //post pic
        picArray[indexPath.row].getDataInBackground { (data: Data?, error: Error?) in
            cell.picImg.image = UIImage(data: data!)
        }
        
        //calc post date
        let from = dateArray[indexPath.row]
        cell.dataLbl.text = "\(from!)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return uuidArray.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

