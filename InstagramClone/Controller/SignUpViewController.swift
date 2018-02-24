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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let profImageTap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.loadImg(recognizer:)))
        profImageTap.numberOfTapsRequired = 1
        profImage.isUserInteractionEnabled = true
        profImage.addGestureRecognizer(profImageTap)
        
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
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
