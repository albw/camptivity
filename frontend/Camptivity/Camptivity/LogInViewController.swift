//
//  SignUpViewController.swift
//  Camptivity
//
//  Created by Khoa Nguyen on 2/10/15.
//  Updated by Phuong Mai on 3/3/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//


import UIKit
import ParseUI

class LogInViewController: UIViewController, PFLogInViewControllerDelegate{
    
    
    
    var logInController: PFLogInViewController = PFLogInViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.hidden = true
        
        self.logInController.delegate = self
        self.logInController.fields = (PFLogInFields.UsernameAndPassword
            | PFLogInFields.LogInButton
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
            //PFUser.logOut()
            self.navigationController!.navigationBar.hidden = false
            self.navigationController?.popViewControllerAnimated(false)
        }
        else{
            self.presentViewController(self.logInController, animated:true, completion: nil)
            let logoView = UIImageView(image: UIImage(named:"Camp_Logo.png"))
            logInController.logInView.logo = logoView
        }
    }
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {

        user.fetchIfNeededInBackground()
        var name = "John"
        if user.objectForKey("name") == nil {
            name = "John"
        }
        else{
            name = user.objectForKey("name") as NSString
        }
        
        var messageTile : String!
        if(name != ""){
            messageTile = "Hello, " + name
        }
        else{
            messageTile = "Hello, There"
        }
        
        
        let alert = UIAlertView()
        alert.title = messageTile
        alert.message = "You've been missed"
        alert.delegate = self
        alert.addButtonWithTitle("Ok")
        alert.show()

        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
}

