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
    
    
    func fetchLocationsBaseOnCategories(categories:[String], completion: (result: [AnyObject])->Void) {
        var results = []
        var query = PFQuery(className: "Locations")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                results = objects
                //NSLog("%@", results)
            }
            else {
                NSLog("%@", error)
            }
            completion(result:results)
            
            
        }
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
    
    /**
    * Identifies locations near a GeoPoint in a specific category. Restricted by radius (miles).
    * Takes 4 params:
    *      category - The String category/categories to select.  This is a String array.
    *      lat - The latitude of the GeoPoint to select.
    *      long - The longditude of the GeoPoint to select.
    *      radius - The radius to search from the specified GeoPoint, in Miles.
    * Example: {"category":["restroom", "bar"], "lat":30, "lon:"30, "radius":40}
    */
    func fetchLocationsNearMe(categories:[String], completion: (returnValue: [AnyObject])->Void) {
//        for search in categories {
//            NSLog(search as NSString)
//        }
        
        PFCloud.callFunctionInBackground("locationsNearMe", withParameters: ["category":categories, "lat":32.88293263160078, "lon":-117.2109485336882, "radius":400]) {
            (objects: AnyObject!, error: NSError!) -> Void in
            var results = []
            if (error != nil) {
                // Your error handling here
            }
            else {
                results = objects as NSArray
                completion(returnValue:results)
                
//                //NSLog("Result: \(result) ")
//                println("===================")
//                
//                for (var i=0; i<results.count; i++)
//                {
//                    //println(results[i]["avgRank"] as Int)
//                    println(results[i]["category"] as String)
//                    //println(results[i]["description"] as String)
//                    //println(results[i]["location"] as PFGeoPoint)
//                    //println(results[i]["name"] as String)
//                    //println(results[i]["numRankings"] as Int)
//                    //println(results[i]["userID"] as PFUser)
//                }
                
                
            }
        }
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
    
    func usernameTaken(username:String)-> Bool {
        var s = Bool()
        //PFCloud.callFunctionInBackground("usernameTaken", withParameters: ["username":"Admin"]) {
        PFCloud.callFunctionInBackground("usernameTaken", withParameters: ["username":username]) {
            (objects: AnyObject!, error: NSError!) -> Void in
            var results = []
            if (error != nil) {
                // Your error handling here
            }
            else {
                
                s = objects as Bool
                
            }
        }
        return s
    }
    
    
    public func newUserSignup(username:String, password:String, email: String, fullname: String)-> (Bool, String) {
        return ParseUser.newUserSignup(username, password: password, email: email, fullname: fullname)
    }

    public func fbSignup(fbID:String, email:String, fullname:String)-> (Bool, String) {
        return ParseUser.fbSignup(fbID, email:email, fullname:fullname)
    }

    func getEvents(limit:Int, skip:Int)->AnyObject {
        let result: AnyObject! = PFCloud.callFunction("getEvents", withParameters: ["limit":limit, "skip":skip])
        return result;
        
    }

    
    /**
    * Posts a new Event object.
    * Takes 7 params:
    *      name - String - the name of the event.
    *      desc - Stirng - The event description.
    *      lat - Number - The event's latitude.
    *      lon - Number - The event's longitude.
    *      user - String - The creator's username.
    *      start - String - The start date. A date/time in ISO 8601, UTC (e.g. "2011-08-21T18:02:52.249Z")
    *      expires - String - The end date. A date/time in ISO 8601, UTC (e.g. "2011-08-21T18:02:52.249Z")
    * Example: {"name":"Ratchet Party", "user":"Admin", "desc": "lets get down n dirty", "lat":32, "lon":-117, "start":"2015-03-21T18:02:52.249Z", "expires":"2015-03-22T18:02:52.249Z"}
    */
    func postEvent(name:String, user:String, desc:String, start:String, expires:String)-> String {
        var s = String()
        //PFCloud.callFunctionInBackground("postEvent", withParameters: ["name":"Ratchet Party", "user":"Admin", "desc": "lets get down n dirty", "lat":32, "lon":-117,"start":"2015-03-21T18:02:52.249Z","expires":"2015-03-22T18:02:52.249Z"]) {
        PFCloud.callFunctionInBackground("postEvent", withParameters: ["name":name, "user":user, "desc": desc, "lat":32, "lon":-117,"start":start,"expires":expires]) {
            (objects: AnyObject!, error: NSError!) -> Void in
            var results = []
            if (error != nil) {
                // Your error handling here
            }
            else {
                
                s = objects as String
                
            }
        }
        return s
    }
    
    /**
    * Posts a new EventVote.
    * Takes 2 params:
    *      user - The user's username
    *      target - The objectId of the Event to post for.
    *  Example: {"user":"Admin", "objectId": "CWwv1FzgPh"}
    */
    func postEventVote(user:String, objectId:String)-> String {
        var s = String()
        //PFCloud.callFunctionInBackground("postEventVote", withParameters: ["user":"Admin", "objectId": "CWwv1FzgPh"]) {
        PFCloud.callFunctionInBackground("postEventVote", withParameters: ["user":user, "objectId": objectId]) {
            (objects: AnyObject!, error: NSError!) -> Void in
            var results = []
            if (error != nil) {
                // Your error handling here
            }
            else {
                
                s = objects as String
                
            }
        }
        return s
    }
    
    /**
    * Gets LocationRanks for the specified Locations object.
    * Takes one param:
    *      objid - The unique objectId of the Location we're trying to get locationRanks for.
    * Example: {"objid":"d70IYXni4G"}
    */
    func getLocationRanks(objid:String)-> AnyObject {
        let result: AnyObject! = PFCloud.callFunction("getLocationRanks", withParameters: ["objid": objid])
        return result;
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

/*
Unit Test code

let provider = ParseDataProvider()
let result: AnyObject! = provider.lookupLocationByCoord(32.880586, long: -117.231874)
println(result.count)
println(result as PFGeoPoint)

*/