//
//  FeedTableViewController.swift
//  Camptivity
//
//  Created by Shayan Mahdavi on 2/16/15.
//  Update by Phuong Mai on 3/11/15
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController  {

    var eventData: [PFObject]!
    var event_index: Int!
    
    //Reference to alertviewcontroller
    var alertController: UIAlertController!
    //Reference to userAlertViewController
    var userAlertController: UIAlertController!
    
    //Reference to alertviewcontroller actions
    var cancel_action: UIAlertAction!
    var login_action: UIAlertAction!
    var signup_action: UIAlertAction!
    var input_action: UIAlertAction!
    //Reference to userAlertViewController actions
    var logout_action: UIAlertAction!
    var userSetting_action: UIAlertAction!
     var resetPwd_action: UIAlertAction!
    
    //Reference to feedtableviewcell
    let feedCellIdentifier = "FeedTableViewCell"
    
   //For now number of events is hardcoded
   //Ideally this would be pagenated, however small user base means
   //we don't need that implementation currently
   var num_event = 0
   var event_count = 200
    
    //TODO Having problems with FUIUIKit atm
    //var alertView : FUIAlertView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigation bar
        //var image: UIImage = UIImage(named: "purplesky")!
        //self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: .Default)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        
        //Initialize AlertController
        alertController = UIAlertController(title: "Let's Start Camping!", message: "Log in to see your profile", preferredStyle: .Alert)
        
        //Closure function for cancel_button action on alert view
        cancel_action = UIAlertAction(title: "Cancel", style: .Cancel) {
            action in
            // ...
        }
        //Closure function for email login action on alert view
        login_action = UIAlertAction(title: "Log In", style: .Default){
            action in
            self.performSegueWithIdentifier("Log_In", sender: nil)
        }
        
        //Closure function for sign up login action on alert view
        signup_action = UIAlertAction(title: "Join Us!", style: .Default){
            action in
            self.performSegueWithIdentifier("Sign_Up", sender: nil)
        }
        
        //Add all actions to the alertviewcontroller
        alertController.addAction(cancel_action)
        alertController.addAction(login_action)
        alertController.addAction(signup_action)
        
        //Initialize userAlertController
        userAlertController = UIAlertController(title: "User's Setting", message: "Click setting to update profile and see your statistics", preferredStyle: .Alert)
        //CLouser function for log out
        logout_action = UIAlertAction(title: "Log Out", style: .Default){
            action in
            PFUser.logOut()
        }
        userSetting_action = UIAlertAction(title: "Settings", style: .Default){
            action in
            self.performSegueWithIdentifier("User_Setting", sender: nil)
        }
        resetPwd_action = UIAlertAction(title: "Reset Password", style: .Default){
            action in
            var email = PFUser.currentUser().email
            var s = PFUser.requestPasswordResetForEmailInBackground(email)
            
            let alert = UIAlertView()
            alert.title = "Reset Password"
            alert.message = "An email was sent to " + email + ". Please follow those intructions to reset password. Thank you."
            alert.delegate = self
            alert.addButtonWithTitle("Dismiss")
            alert.show()
            
        }
        //Add actions to userAlertController
        userAlertController.addAction(logout_action)
        userAlertController.addAction(cancel_action)
        userAlertController.addAction(userSetting_action)
        userAlertController.addAction(resetPwd_action)
        //Getting Event Data from Parse Database
        eventData = ParseEvents.getEvents(limit: event_count, skip:0)
        num_event = eventData.count
        
        //Nav bar adjusting based on login state will go here
        //var post_button = UIBarButtonItem(title: "Add Post", style: .Done, target: self, action: nil)
        //self.navigationItem.leftBarButtonItem = post_button
        
        //TODO Fix FUIUIKit Functionality Later
        //alertView = FUIAlertView()
        //alertView.titleLabel.textColor = UIColor.cloudsColor()
        //alertView.show()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return num_event
    }
    
    /*
    * Login button is clicked, will present the uialertviewcontroller
    */
    @IBAction func triggerUserLogin(sender: AnyObject) {
        
        if (PFUser.currentUser() != nil){
            self.presentViewController(userAlertController, animated: true) {}
        }
        else{
            self.presentViewController(alertController, animated: true) {}
        }
    }
    
    @IBAction func upVote(sender: UIButton) {
        println("Debug: Upvote \(sender.tag)")
        //TODO: Access username if possible, can only vote if logged in
        //Maybe prompt them if they aren't logged in?
        let user = PFUser.currentUser()
        
        if(user == nil){
            return //No user logged in
        }
        
        let success = ParseEvents.postEventVote(user.username, objId: eventData[sender.tag].objectId, isUpVote: true)
        println("success = \(success)")
        if(success){
            //TODO: Need to update View and vote count
            println("vote is a success")
            let count = ParseEvents.countEventVotes(eventData[sender.tag].objectId)
            let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as FeedTableViewCell!
            cell.count.text = String(count)
        }
        //Else just do nothing
    }
    
    @IBAction func downVote(sender: UIButton) {
        println("Debug: Down Vote on \(sender.tag)")

        //Maybe prompt them if they aren't logged in?
        let user = PFUser.currentUser()
        
        if(user == nil){
            return //No user logged in
        }
        
        let success = ParseEvents.postEventVote(user.username, objId: eventData[sender.tag].objectId, isUpVote: false)
        println("success = \(success)")
        if(success){
            //TODO: Need to update View and vote count
            println("vote is a success")
            let count = ParseEvents.countEventVotes(eventData[sender.tag].objectId)
            let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as FeedTableViewCell!
            cell.count.text = String(count)
        }
        //Else just do nothing
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        return feedCellAtIndexPath(indexPath)
    }
    
    func feedCellAtIndexPath(indexPath:NSIndexPath) -> FeedTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell") as FeedTableViewCell
        cell.up_button.tag = indexPath.row
        cell.down_button.tag = indexPath.row
        if(indexPath.row < num_event){ //Currently hardcoded, need a way to determine the amount of events
          setCellDisplay(cell, indexPath: indexPath)
        }
        return cell
    }
    
    //Helper Function for setting all relevent cell displays
    func setCellDisplay(cell:FeedTableViewCell, indexPath:NSIndexPath) {
        
        if(indexPath.row >= eventData.count){
            return //Don't need to display cell no more cells to display
        }
        
        let data = eventData[indexPath.row] as AnyObject!
        if(data != nil){
            //Update cells to display relevent Event Data
            cell.title_label.text = eventData[indexPath.row]["name"] as String!
            cell.description_label.text = eventData[indexPath.row]["description"] as String!
        
            //Diplay upvote count for event cell
            let count = eventData[indexPath.row]["upVotes"] as Int
            cell.count.text = String(count)
        
            //Display username for event cell
            let user = eventData[indexPath.row]["userID"] as PFUser!
            if( user != nil){
                cell.username_label.text = user.objectForKey("username") as String!
            }
            
            // this code added by Phuong Mai
            let dataProvider = ParseDataProvider()
            
            let ojbID = eventData[indexPath.row].objectId as String
            var query = PFQuery(className:"Events")
            query.getObjectInBackgroundWithId(ojbID) {
                (obj: PFObject!, error: NSError!) -> Void in
                if error != nil {
                    NSLog("%@", error)
                } else {

                    if let userImageFile = obj["icon"] as? PFFile {

                        userImageFile.getDataInBackgroundWithBlock {
                            (imageData: NSData!, error: NSError!) -> Void in
                            if error == nil {
                                cell.profile_image.image = UIImage(data:imageData)
                            }
                        }
                    }
                }
            }
            // end code
        }
        
    }
    
    //Override function for table cell clicks
    //Precondition: Global struct array to hold all event data will be populated after call for getEvents
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Row \(indexPath.row)" )
        event_index = indexPath.row
        performSegueWithIdentifier("Event_Segue", sender: nil)
    }
    
    //This gets called before any segue occurs from this view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if( segue.identifier == "Event_Segue")
        {
            // Create a variable that you want to send
            var name = "Test"
        
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destinationViewController as EventViewController
            
            //Pass in Event description data
            destinationVC.name = eventData[event_index]["name"] as String
            destinationVC.details = eventData[event_index]["description"] as String
            
            //Pass in username
            let user = eventData[event_index]["userID"] as PFUser!
            destinationVC.username = user.objectForKey("username") as String!
            //destinationVC.username = "Derp"
            
            //Pass Location
            let geo = eventData[event_index]["location"] as PFGeoPoint!
            destinationVC.long = geo.longitude
            destinationVC.lat = geo.latitude
        }
        
    }

}
