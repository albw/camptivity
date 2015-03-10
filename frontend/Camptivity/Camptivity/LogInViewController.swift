//
//  SignUpViewController.swift
//  Camptivity
//
//  Created by Khoa Nguyen on 2/10/15.
//  Updated by Phuong Mai on 3/3/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

//import UIKit
//
//class LogInViewController: UIViewController {
//
//    @IBOutlet weak var userName: UITextField!
//    @IBOutlet weak var userPassword: UITextField!
//
//
//       @IBAction func loginVerifyButton(sender: AnyObject) {
//        var usrEntered = userName.text
//        var pwdEntered = userPassword.text
//        var userID : String!
//        if usrEntered != "" && pwdEntered != "" {
//            let provider = ParseDataProvider()
//             userID  = provider.login(usrEntered, password: pwdEntered).objectId
//
//
//
//            let alert = UIAlertView()
//            alert.title = "Logged in"
//            alert.message =   userID
//            alert.delegate = self
//            alert.addButtonWithTitle("#Truuuuuuu")
//            alert.show()
//
//            println(userID)
//
//        } else {
//            //self.messageLabel.text = "All Fields Required"
//        }
//
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//
//    }
//
//
//}

import UIKit
import ParseUI

class LogInViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate{
    
    
    
    var logInController: PFLogInViewController = PFLogInViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.hidden = true
        
        
        self.logInController.fields = (PFLogInFields.UsernameAndPassword
            | PFLogInFields.LogInButton
            | PFLogInFields.SignUpButton
            | PFLogInFields.PasswordForgotten
            | PFLogInFields.DismissButton
            | PFLogInFields.Facebook)
        
        self.logInController.logInView.dismissButton.addTarget(self, action: "dismissAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.logInController.logInView.logInButton.setTitle("Camp'in !", forState: UIControlState.Normal)
        
    }
    
    func dismissAction(sender:UIButton!){
        self.navigationController!.navigationBar.hidden = false
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() != nil){
            //User logged in
        }
        else{
            self.logInController.delegate = self
            
            self.presentViewController(self.logInController, animated:true, completion: nil)
            
            
            
            let logoView = UIImageView(image: UIImage(named:"Camp_Logo.png"))
            logInController.logInView.logo = logoView
            
        }
    }
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        let alert = UIAlertView()
        alert.title = "Success Log In"
        alert.message = user.objectId as String
        alert.delegate = self
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        let alert = UIAlertView()
        alert.title = "Success Sign Up"
        alert.message = user.objectId as String
        alert.delegate = self
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
}

