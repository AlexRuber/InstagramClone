//
//  ViewController.swift
//  InstagramClone
//
//  Created by Mihai Ruber on 2/23/18.
//  Copyright © 2018 Mihai Ruber. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let object = PFObject(className: "Test")
        object["name"] = "Bill"
        object.saveInBackground { (done: Bool, error: Error?) in
            if done {
                print("Saved in server")
            } else {
                print(error)
            }
        }
        
        let info = PFQuery(className: "Test")
        info.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if error == nil {
                for object in objects! {
                    print(object)
                }
            } else {
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

