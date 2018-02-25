//
//  SignInViewController.swift
//  InstagramClone
//
//  Created by Mihai Ruber on 2/23/18.
//  Copyright © 2018 Mihai Ruber. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController {

    // Outlets
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    
    // Variables
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // Actions
    @IBAction func loginBtnTapped(_ sender: Any) {
        
        if (usernameTxt.text?.isEmpty == true || passwordTxt.text?.isEmpty == true) {
            let alert = UIAlertController(title: "Error", message: "Fill in all the fields", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        self.view.endEditing(true)
        
        PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user: PFUser?, error: Error?) in
            if error == nil {
                UserDefaults.standard.set(user!.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                // call login function from app delegate
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
            } else {
                // there was an error logging in
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    
    
    

}
