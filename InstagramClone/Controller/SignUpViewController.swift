//
//  SignUpViewController.swift
//  InstagramClone
//
//  Created by Mihai Ruber on 2/23/18.
//  Copyright © 2018 Mihai Ruber. All rights reserved.
//

import UIKit
import Parse
import IQKeyboardManagerSwift

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Variables
    var scrollViewHeight: CGFloat = 0
    
    // Outlets
    @IBOutlet weak var profImage: UIImageView!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPassTxt: UITextField!
    @IBOutlet weak var fullNameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let profImageTap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.loadImg(recognizer:)))
        profImageTap.numberOfTapsRequired = 1
        profImage.isUserInteractionEnabled = true
        profImage.addGestureRecognizer(profImageTap)
        
        // Setting a circle
        profImage.layer.cornerRadius = profImage.frame.size.width / 2
        profImage.clipsToBounds = true
        // Do any additional setup after loading the view.
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
    
    // connect selected image to our image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        if (usernameTxt.text?.isEmpty == true || passwordTxt.text?.isEmpty == true || repeatPassTxt.text?.isEmpty == true || fullNameTxt.text?.isEmpty == true || bioTxt.text?.isEmpty == true || webTxt.text?.isEmpty == true || emailTxt.text?.isEmpty == true) {
            let alert = UIAlertController(title: "Error", message: "Fill in all the fields", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        if (passwordTxt.text != repeatPassTxt.text) {
            let alert = UIAlertController(title: "Password Error", message: "Passwords don't match", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        // Send data to server
        let user = PFUser()
        user.username = usernameTxt.text?.lowercased()
        user.email = emailTxt.text?.lowercased()
        user.password = passwordTxt.text?.lowercased()
        user["fullname"] = fullNameTxt.text?.lowercased()
        user["bio"] = bioTxt.text?.lowercased()
        user["website"] = webTxt.text?.lowercased()
        user["tel"] = ""
        user["gender"] = ""
        
        // convert image for sending to server
        let profData = UIImageJPEGRepresentation(profImage.image!, 0.5)
        let profFile = PFFile(name: "prof.jpg", data: profData!)
        user["profImg"] = profFile
        
        // save data in server
        user.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                print("registered!")
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
