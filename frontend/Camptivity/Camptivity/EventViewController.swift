//
//  EventViewController.swift
//  Camptivity
//
//  Created by Shayan Mahdavi on 3/3/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var username_label: UILabel!
    @IBOutlet weak var description_label: UILabel!
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var imgVier: UIImageView!
    
    let pin_button = UIButton.buttonWithType(UIButtonType.System) as UIButton
    
    var name: String!
    var details: String!
    var username: String!
    var lat: Double!
    var long: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("In Event View")
        println(name)
        println(details)
        
        title_label.text = name
        description_label.text = details
        username_label.text = username
        
        // this code added by Phuong Mai
        // load back object to get objectId, because upload icom need objectId
        var obj = ParseEvents.getEventByName(name)
        
        var query = PFQuery(className:"Events")
        query.getObjectInBackgroundWithId(obj.objectId) {
            (obj: PFObject!, error: NSError!) -> Void in
            if error != nil {
                NSLog("%@", error)
            } else {
                
                if let userImageFile = obj["icon"] as? PFFile {
                    
                    userImageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData!, error: NSError!) -> Void in
                        if error == nil {
                            self.imgVier.image = UIImage(data:imageData)
                        }
                    }
                }
            }
        }
        // end code
        
        pin_button.frame = CGRectMake(100, 100, 100, 50)
        pin_button.setTitle("Pin to Map", forState: UIControlState.Normal)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let buttonX = (screenSize.width/2) - 50
        let buttonY = screenSize.height - 200
        
        pin_button.frame = CGRectMake(buttonX, buttonY, 100, 50)
        
        pin_button.addTarget(self, action: "pinAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(pin_button)

        //For when we want to add commenting
        //let comment_button = UIBarButtonItem(title: "Comment", style: .Done, target: self, action: nil)
        //self.navigationItem.rightBarButtonItem = comment_button
        
        // Do any additional setup after loading the view.
    }
    
    func pinAction(sender:UIButton!){
        //TODO pass in actual long and lat values from database
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.doPin = true
        appDelegate.lat = lat //Set your latitude here
        appDelegate.long = long //Set your longitude here
        appDelegate.name = name //Set Event Name
        appDelegate.event_description = details //Set Description
        self.tabBarController?.selectedIndex = 0 //Moves to map view
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
