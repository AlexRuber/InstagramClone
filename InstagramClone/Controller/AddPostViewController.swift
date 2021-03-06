//
//  AddPostViewController.swift
//  InstagramClone
//
//  Created by Mihai Ruber on 2/25/18.
//  Copyright © 2018 Mihai Ruber. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Parse

class AddPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Outlets
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var titleTxt: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picImg.image = UIImage(named: "addImage")
        titleTxt.text = ""
        
        // Add image tapped
        let addImageTap = UITapGestureRecognizer(target: self, action: #selector(AddPostViewController.loadImg(recognizer:)))
        addImageTap.numberOfTapsRequired = 1
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(addImageTap)
        
        // Init view
        postBtn.isEnabled = false
        postBtn.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        // Do any additional setup after loading the view.
        alignment()
    }

    // Actions
    // call picker to select image
    @objc func loadImg(recognizer: UITapGestureRecognizer) {
            let picker = UIImagePickerController()
            picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            print("Camera is available 📸")
            //picker.sourceType = .camera
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            
        } else {
            picker.sourceType = .photoLibrary
            print("Camera 🚫 available so we will use photo library instead")
        
        }
        present(picker, animated: true, completion: nil)

    
    }
    
    func alignment() {
        let width = self.view.frame.size.width
        picImg.frame = CGRect(x: 15, y: (self.navigationController!.navigationBar.frame.size.height) + 35, width: width / 4.5, height: width / 4.5)

    }
    
    // hold selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        // enable add image button
        postBtn.isEnabled = true
        postBtn.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        
        // implement second zoom tap
        let zoomTap = UITapGestureRecognizer(target: self, action: #selector(AddPostViewController.zoom))
        zoomTap.numberOfTapsRequired = 1
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(zoomTap)
    }
    
    // click post button
    @IBAction func postImagePressed(_ sender: Any) {
        self.view.endEditing(true)
        
        // send data to posts class in parse
        let object = PFObject(className: "posts")
        object["username"] = PFUser.current()!.username
        object["profImg"] = PFUser.current()!.value(forKey: "profImg") as! PFFile
        object["uuid"] = "\(PFUser.current()!.username) \(NSUUID().uuidString)"
        
        if titleTxt.text.isEmpty == true {
            object["title"] = ""
        } else {
            object["title"] = titleTxt.text
        }
        
        let imageData = UIImageJPEGRepresentation(picImg.image!, 0.5)
        let imageFile = PFFile(name: "post.jpg", data: imageData!)
        object["pic"] = imageFile
        
        object.saveInBackground { (success: Bool, error: Error?) in
            if error == nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uploaded"), object: nil)
                self.tabBarController!.selectedIndex = 0
                print("succesfuly posted!")
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    @IBAction func removeTapped(_ sender: Any) {
        self.viewDidLoad()
    }
    
    
    
    //Zoom in function
    @objc func zoom() {
        // unzoomed
        let width = self.view.frame.size.width
        let unzoomed = CGRect(x: 15, y: (self.navigationController!.navigationBar.frame.size.height) + 35, width: width / 4.5, height: width / 4.5)
        
        // zoomed
        let zoomed = CGRect(x: 0, y: self.view.center.y - self.view.center.x - 85, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        if picImg.frame == unzoomed {
            UIView.animate(withDuration: 0.3, animations: {
                self.picImg.frame = zoomed
                self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.titleTxt.alpha = 0
                self.postBtn.alpha = 0
                
            })
        } else {
            // if already zoomed
            UIView.animate(withDuration: 0.3, animations: {
                self.picImg.frame = unzoomed
                self.view.backgroundColor = #colorLiteral(red: 0.9999127984, green: 1, blue: 0.9998814464, alpha: 1)
                self.titleTxt.alpha = 1
                self.postBtn.alpha = 1
                
            })
        }
    }

}
