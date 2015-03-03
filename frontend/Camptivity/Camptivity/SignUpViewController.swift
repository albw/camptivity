//
//  SignUpViewController.swift
//  Camptivity
//
//  Created by Khoa Nguyen on 2/10/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import UIKit



class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var fullName: UITextField!
    
    @IBAction func loginVerifyButton(sender: AnyObject) {
        var usrEntered = userName.text
        var pwdEntered = userPassword.text
        var emlEntered = userEmail.text
        var nameEntered = fullName.text
        
        if usrEntered != "" && pwdEntered != "" && emlEntered != "" {
            let provider = ParseDataProvider()
            var s  = provider.newUserSignup(usrEntered, password:pwdEntered, email:emlEntered, fullname: nameEntered)
            
            let alert = UIAlertView()
            alert.title = "Signed Up"
            alert.message = "Successfully signed up on Parse"
            alert.delegate = self
            alert.addButtonWithTitle("Ok")
            alert.show()

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


