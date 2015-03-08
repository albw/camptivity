//
//  FacebookLoginViewController.swift
//  Camptivity
//
//  Created by Khoa Nguyen on 2/10/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import UIKit
import Parse

class FacebookLoginViewController: UIViewController, FBLoginViewDelegate {
    
    @IBOutlet var fbLoginView : FBLoginView!
    var fullName : String!
    var email: String!
    var userID : String!
    var userName : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
    }
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        self.fullName = user.first_name + " " + user.last_name
        self.userID =  user.objectID
        self.userName = user.username
        
        if (self.userID != nil)
        {
            
            let provider = ParseDataProvider()
            var s = provider.fbRegistered(self.userID)
            if (s != nil){
                println(s)
            }
      

            
            
            else{
                //No User, send to signup
                FBRequestConnection.startForMeWithCompletionHandler { (connection, user, error) -> Void in
                    if (error == nil)
                    {
                        self.email = user.objectForKey("email") as String
                        self.performSegueWithIdentifier("showView", sender: self)
                        
                    }
                }
            }
            
        }
        
    }
    
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "showView"){
            var vc: FBSignUpViewController = segue.destinationViewController as FBSignUpViewController
            vc.fullName = self.fullName
            vc.email = self.email
            vc.userID = self.userID

            
        }
        
    }

    
}


