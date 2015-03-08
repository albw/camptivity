//
//  FeedTableViewController.swift
//  Camptivity
//
//  Created by Shayan Mahdavi on 2/16/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {

    var eventData: NSArray!
    var event_index: Int!
    
    //Reference to alertviewcontroller
    var alertController: UIAlertController!
    
    //Reference to alertviewcontroller actions
    var cancel_action: UIAlertAction!
    var fb_login_action: UIAlertAction!
    var email_login_action: UIAlertAction!
    var signup_action: UIAlertAction!
    var input_action: UIAlertAction!
    
    //Reference to feedtableviewcell
    let feedCellIdentifier = "FeedTableViewCell"
    
    //Reference to middleware function calls
    var data_provider: ParseDataProvider!
   
    //TODO Having problems with FUIUIKit atm
    //var alertView : FUIAlertView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize AlertController
        alertController = UIAlertController(title: "Default Style", message: "A standard alert.", preferredStyle: .Alert)
        
        //Closure function for cancel_button action on alert view
        cancel_action = UIAlertAction(title: "Cancel", style: .Cancel) {
            action in
            // ...
        }
        
        //Closure function for facebook login action on alert view
        fb_login_action = UIAlertAction(title: "Facebook Login", style: .Default) {
            action in
            self.performSegueWithIdentifier("FB_Login", sender: nil)
            // ...
        }
        
        //Closure function for email login action on alert view
        email_login_action = UIAlertAction(title: "Login", style: .Default){
            action in
            self.performSegueWithIdentifier("Log_In", sender: nil)
        }
        
        //Closure function for sign up login action on alert view
        signup_action = UIAlertAction(title: "Sign Up", style: .Default){
            action in
            self.performSegueWithIdentifier("Sign_Up", sender: nil)
        }
        
        //Add all actions to the alertviewcontroller
        alertController.addAction(cancel_action)
        alertController.addAction(fb_login_action)
        alertController.addAction(email_login_action)
        alertController.addAction(signup_action)
        
        //Getting Event Data from Parse Database
        data_provider = ParseDataProvider()
        eventData = data_provider.getEvents(3, skip:1) as NSArray
        
        //Print debug data of first event gathered
        println(eventData[0])
        
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
        return 3 //Currently hardcoded, need a way to determine the amount of events
    }
    
    /*
    * Login button is clicked, will present the uialertviewcontroller
    */
    @IBAction func triggerUserLogin(sender: AnyObject) {
        
        self.presentViewController(alertController, animated: true) {}
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        return feedCellAtIndexPath(indexPath)
    }
    
    func feedCellAtIndexPath(indexPath:NSIndexPath) -> FeedTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell") as FeedTableViewCell
        if(indexPath.row < 2){ //Currently hardcoded, need a way to determine the amount of events
          setCellDisplay(cell, indexPath: indexPath)
        }
        return cell
    }
    
    //Helper Function for setting all relevent cell displays
    func setCellDisplay(cell:FeedTableViewCell, indexPath:NSIndexPath) {
        cell.title_label.text = eventData[indexPath.row]["name"] as String
        cell.description_label.text = eventData[indexPath.row]["description"] as String
        let count = eventData[indexPath.row]["upVotes"] as Int
        cell.count.text = String(count)
    }
    
    //Override function for table cell clicks
    //Precondition: Global struct array to hold all event data will be populated after call for getEvents
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Row \(indexPath.row)" )
        event_index = indexPath.row
        performSegueWithIdentifier("Event_Segue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if( segue.identifier == "Event_Segue")
        {
            // Create a variable that you want to send
            var name = "Test"
        
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destinationViewController as EventViewController
            destinationVC.name = eventData[event_index]["name"] as String
            destinationVC.details = eventData[event_index]["description"] as String
            destinationVC.username = "John Doe"
        }
        
    }

}
