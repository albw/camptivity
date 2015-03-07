//
//  SignUpViewController.swift
//  Camptivity
//
//  Created by Khoa Nguyen on 2/10/15.
//  Updated by Phuong Mai on 3/3/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    
       @IBAction func loginVerifyButton(sender: AnyObject) {
        var usrEntered = userName.text
        var pwdEntered = userPassword.text
        var userID : String!
        if usrEntered != "" && pwdEntered != "" {
            let provider = ParseDataProvider()
             userID  = provider.login(usrEntered, password: pwdEntered)
            
            let alert = UIAlertView()
            alert.title = "Logged in"
            alert.message =   "  "
            alert.delegate = self
            alert.addButtonWithTitle("#Truuuuuuu")
            alert.show()
            
            println(userID)
            
        } else {
            //self.messageLabel.text = "All Fields Required"
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}


