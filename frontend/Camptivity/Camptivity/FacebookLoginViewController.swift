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
    var firstName: String!
    var lastName: String!
    var email: String!
    var userID : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
    }
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        println("This is where you perform a segue.")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        self.firstName = user.first_name
        self.lastName = user.last_name
        self.userID =  user.objectID
        FBRequestConnection.startForMeWithCompletionHandler { (connection, user, error) -> Void in
            if (error == nil)
            {
                self.email = user.objectForKey("email") as String
                self.performSegueWithIdentifier("showView", sender: self)
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
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if (segue.identifier == "showView"){
//            var vc: AfterLoggedInFB = segue.destinationViewController as AfterLoggedInFB
//            vc.firstName = self.firstName
//            vc.lastName = self.lastName
//            vc.userID = self.userID
//            vc.email = self.email
//        }
//        
//    }
    
    
}


