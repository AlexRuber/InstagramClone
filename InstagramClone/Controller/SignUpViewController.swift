//
//  SignUpViewController.swift
//  InstagramClone
//
//  Created by Mihai Ruber on 2/23/18.
//  Copyright © 2018 Mihai Ruber. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
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
    @IBOutlet weak var scrollView: UIScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
