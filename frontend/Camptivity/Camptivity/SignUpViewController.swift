//
//  SignUpViewController.swift
//  Camptivity
//
//  Created by Khoa Nguyen on 2/10/15.
//

import UIKit
import ParseUI

class SignUpViewController: UIViewController, PFSignUpViewControllerDelegate{
    
    var signUpController : PFSignUpViewController = PFSignUpViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.hidden = true
        self.signUpController.delegate = self
        self.signUpController.fields = (PFSignUpFields.Additional|PFSignUpFields.Default)
        self.signUpController.signUpView.signUpButton.setTitle("Camp up!", forState: UIControlState.Normal)
        self.signUpController.signUpView.additionalField.placeholder = "Full Name (Optional)"
        self.signUpController.signUpView.dismissButton.addTarget(self, action: "dismissAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func dismissAction(sender:UIButton!){
        self.navigationController!.navigationBar.hidden = false
        self.navigationController?.popViewControllerAnimated(false)
    }

    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() != nil){
            //User logged in
            //PFUser.logOut()
            self.navigationController!.navigationBar.hidden = false
            self.navigationController?.popViewControllerAnimated(false)
        }
        else{
            self.presentViewController(self.signUpController, animated:true, completion: nil)
            let logoView = UIImageView(image: UIImage(named:"Camp_Logo.png"))
            signUpController.signUpView.logo = logoView


        }
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        var fullName = signUpController.signUpView.additionalField.text
        user["name"] = fullName
        user.saveInBackground()
        
        var messageTile : String!
        if(fullName != ""){
            messageTile = "Welcome, " + fullName
        }
        else{
            messageTile = "Welcome, New Friend!"
        }
        
        
        let alert = UIAlertView()
        alert.title = messageTile
        alert.message = "Thank you for joining us! An email was sent to " + user.email + " for comfirmation."
        alert.delegate = self
        alert.addButtonWithTitle("Ok")
        alert.show()
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
