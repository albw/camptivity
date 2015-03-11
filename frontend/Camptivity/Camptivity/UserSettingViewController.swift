//
//  UserSettingViewController.swift
//  Camptivity
//
//  Created by Khoa Nguyen on 3/10/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//
import UIKit

class UserSettingViewController: UIViewController{
    
    
    
    @IBOutlet weak var userGreetting: UILabel!
    @IBOutlet weak var newUsername: UITextField!
    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var newName: UITextField!
    
    var newUserNameEntered: String!
    var newEmailEntered: String!
    var newNameEntered: String!
    
    @IBAction func settingButton(sender: AnyObject){
        
        if (PFUser.currentUser() != nil){
            var user = PFUser.currentUser()
            
            self.newUserNameEntered = newUsername.text
            self.newEmailEntered = newEmail.text
            self.newNameEntered = newName.text
            
            if(newUserNameEntered == "" && newEmailEntered == "" && newNameEntered == ""){
                let alert = UIAlertView()
                alert.title = "Empty Fields"
                alert.message = "Please enter at least one new setting field"
                alert.delegate = self
                alert.addButtonWithTitle("Dismiss")
                alert.show()
            }
            else{
                if(newUserNameEntered != ""){
                    user.username = newUserNameEntered
                }
                if(newEmailEntered != ""){
                    user["email"] = newEmailEntered
                }
                if(newNameEntered != ""){
                    user["name"] = newNameEntered
                }
                user.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError!) -> Void in
                    if (success) {
                        let alert = UIAlertView()
                        alert.title = "Successfully Updated"
                        alert.message = "Please remember your new information"
                        alert.delegate = self
                        alert.addButtonWithTitle("Dismiss")
                        alert.show()
                        self.navigationController!.navigationBar.hidden = false
                        self.navigationController?.popViewControllerAnimated(false)
                    } else {
                        let alert = UIAlertView()
                        alert.title = "Unsuccessful Update"
                        alert.message = "Please try again"
                        alert.delegate = self
                        alert.addButtonWithTitle("Dismiss")
                        alert.show()
                        
                    }
                }
            }
        }
    }
    
    @IBAction func resetButton(sender: AnyObject){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(PFUser.currentUser() != nil){
            var user = PFUser.currentUser()
            user.fetchIfNeededInBackground()
            var name  = user.objectForKey("name") as String
            var label: String!
            if(name != ""){
                label = name + "'s Profile Update"
            }
            else{
                label = "Your Profile Update"
            }
            self.userGreetting.text = label
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

    