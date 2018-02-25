//
//  ResetPasswordViewController.swift
//  InstagramClone
//
//  Created by Mihai Ruber on 2/23/18.
//  Copyright © 2018 Mihai Ruber. All rights reserved.
//

import UIKit
import Parse
import IQKeyboardManagerSwift

class ResetPasswordViewController: UIViewController {
    
    // Variables
    
    // Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // Actions

    @IBAction func resetBtnClicked(_ sender: Any) {
        if (emailTxt.text?.isEmpty == true) {
            let alert = UIAlertController(title: "Error", message: "Fill in all the fields", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        self.view.endEditing(true)
        
        PFUser.requestPasswordResetForEmail(inBackground: emailTxt.text!) { (success: Bool, error: Error?) in
            if success {
                let alert = UIAlertController(title: "Email for reseting password", message: "has been sent to texted email", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
