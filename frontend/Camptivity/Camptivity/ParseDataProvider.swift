//
//  ParseDataProvider.swift
//  Camptivity
//
//  Created by SI  on 2/12/15.
//  Update by Phuong Mai on 2/17/2015
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import Foundation
import Parse

public class ParseDataProvider {
    let apiKey = "AIzaSyCNjX-9jxGqB9BcMeCx6tPJR1l0WU58LSA"
    var session: NSURLSession {
        return NSURLSession.sharedSession()
    }
    
    func fetchDirectionsFrom(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completion: ((String?) -> Void)) -> ()
    {
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?key=\(apiKey)&origin=\(from.latitude),\(from.longitude)&destination=\(to.latitude),\(to.longitude)&mode=walking"
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        session.dataTaskWithURL(NSURL(string: urlString)!) {data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            var encodedRoute: String?
            if let json = NSJSONSerialization.JSONObjectWithData(data, options:nil, error:nil) as? [String:AnyObject] {
                if let routes = json["routes"] as AnyObject? as? [AnyObject] {
                    if let route = routes.first as? [String : AnyObject] {
                        if let polyline = route["overview_polyline"] as AnyObject? as? [String : String] {
                            if let points = polyline["points"] as AnyObject? as? String {
                                encodedRoute = points
                            }
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(encodedRoute)
            }
            }.resume()
    }
    
    
    ///BROKEN SHIT.  Left here to shut up compiler.
    func fetchLocationsNearMe(categories:[String], completion: (returnValue: [AnyObject])->Void) {
        assert(false, "METHOD IS DEPRECEATED.  Use ParseLocations.getLocationsNearMe()")
    }
    
    
    // Function return true if an email already used. False Other wise.
    func emailRegistered(email:String)-> Bool {
        var s = Bool()
        var query = PFUser.query()
        query.whereKey("email", equalTo:email)
        var obj = query.findObjects()
        
        if (obj.count != 0){
            s = true
        }
        else {
            s = false
        }
        return s
    }
    
    
    func fbRegistered(facebookID:String)-> String! {
        var s : String!
        var query = PFUser.query()
        query.whereKey("fbID", equalTo:facebookID)
        var obj = query.findObjects()
        if let obj = obj as?  [PFObject]{
            s = obj.first?.objectId
        }
        
        return s
        
    }
    
    // need #import <Bolts/Bolts.h> in Bridging Header
    /**
    * Save Icon to Parse.
    * Takes 4 params:
    *      className - String - The table name
    *      objID - String - The object ID.
    *      colName - String - the column name
    *      img - PFFile - The image.
    *  Example: {"className":"Events", "objID": "uqBzdjmha1", "colName":"icon", PFFile(data:imageData)}
    */
    func saveIcon(className:String, objID:String, colName:String, img:PFFile)-> Void {
        
        // the code upload picture/icon to Parse
        var query = PFQuery(className: className)
        query.getObjectInBackgroundWithId(objID) {
            (obj: PFObject!, error: NSError!) -> Void in
            if error != nil {
                NSLog("%@", error)
            } else {
                
                /*
                // Recipe image
                var imageData = NSData()
                //imageData = UIImageJPEGRepresentation(self.imgView.image, 0.8)
                
                var imageFile = PFFile(data:imageData)
                obj["photo"] = imageFile
                */
                obj[colName] = img
                obj.saveInBackgroundWithTarget(nil, selector: nil)
            }
        }
    }
    
    /**
    * Login.
    * Takes 2 params:
    *      username - String - User name
    *      password - String - Password
    *  Example: {"username":"username", "password": "password"}
    */
    func login(username:String, password:String)-> PFUser {
        
        // the code upload picture/icon to Parse
        return PFUser.logInWithUsername(username, password: password);
        
        
    }
    
    func saveImageToPictureProfile(username:String, password:String, imageFile:PFFile)-> Void {
        
        // the code upload picture/icon to Parse
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                // Yes, User Exists
                // Recipe image
                //var imageData = NSData()
                //imageData = UIImageJPEGRepresentation(self.imgView.image, 0.8)
                
                //var imageFile = PFFile(data:imageData)
                user.setObject(imageFile, forKey: "profilePic")
                user.saveInBackgroundWithTarget(nil, selector: nil)
                
            } else {
                // No, User Doesn't Exist
            }
        }
    }
    
    /**
    * Load Icon from Parse.
    * Takes 3 params:
    *      className - String - The table name
    *      objID - String - The object ID.
    *      colName - String - the column name
    * return NSData is binary of image
    *  Example: {"className":"Events", "objID": "uqBzdjmha1", "colName":"icon"}
    */
    func loadIcon(className:String, objID:String, colName:String)-> NSData {
        
        // the code load picture/icon from Parse
        var r = NSData()
        var query = PFQuery(className:"EventCmt")
        query.getObjectInBackgroundWithId("TuyyHRLHDm") {
            (obj: PFObject!, error: NSError!) -> Void in
            if error != nil {
                NSLog("%@", error)
            } else {
                
                let userImageFile = obj[colName] as PFFile
                userImageFile.getDataInBackgroundWithBlock {
                    (imageData: NSData!, error: NSError!) -> Void in
                    if error == nil {
                        //self.imgView2.image = UIImage(data:imageData)
                        r = imageData
                        
                    }
                }
            }
        }
        return r
    }
}