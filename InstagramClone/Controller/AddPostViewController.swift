//
//  AddPostViewController.swift
//  InstagramClone
//
//  Created by Mihai Ruber on 2/25/18.
//  Copyright © 2018 Mihai Ruber. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AddPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Outlets
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var titleTxt: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
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
