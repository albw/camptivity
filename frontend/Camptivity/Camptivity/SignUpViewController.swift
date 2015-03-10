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
        self.signUpController.fields = (PFSignUpFields.Default)
        self.signUpController.signUpView.signUpButton.setTitle("Camp up!", forState: UIControlState.Normal)
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
        }
        else{
            self.presentViewController(self.signUpController, animated:true, completion: nil)
            let logoView = UIImageView(image: UIImage(named:"Camp_Logo.png"))
            signUpController.signUpView.logo = logoView
        }
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
