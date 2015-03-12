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
    @IBOutlet weak var eventComments: UILabel!
    @IBOutlet weak var createdEvents: UILabel!
    @IBOutlet weak var locationRanked: UILabel!
    @IBOutlet weak var votesGiven: UILabel!
    @IBOutlet weak var votesRecieved: UILabel!

    
    
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
                label = name + "'s Profile"
            }
            else{
                label = "Your Profile"
            }
            
            var score = ParseScore.getUserScore(user.username)
            println(score)
            var eventCommentInt = score["eventComments"] as Int
            var eventCreatedInt = score["eventsCreated"] as Int
            var locationRankedInt = score["locationsRanked"] as Int
            var votesGivenInt = score["votesGiven"] as Int
            var votesRecievedInt = score["votesReceived"] as Int
            
            self.eventComments.text = "Event Comments: " + String(eventCommentInt)
            self.createdEvents.text = "Event Created: " + String(eventCommentInt)
            self.locationRanked.text = "Locations Rank: " + String(locationRankedInt)
            self.votesGiven.text = "Votes Given: " + String(votesGivenInt)
            self.votesRecieved.text = "Votes Recieved: " + String(votesRecievedInt)
            self.userGreetting.text = label
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

    