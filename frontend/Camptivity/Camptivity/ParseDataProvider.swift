//
//  ParseDataProvider.swift
//  Camptivity
//
//  Created by SI  on 2/12/15.
//  Update by Phuong Mai on 2/17/2015
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//


class ParseDataProvider {
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
        for search in categories {
            NSLog(search as NSString)
        }
        
        PFCloud.callFunctionInBackground("locationsNearMe", withParameters: ["category":categories, "lat":32.88293263160078, "lon":-117.2109485336882, "radius":400]) {
            (objects: AnyObject!, error: NSError!) -> Void in
            var results = []
            if (error != nil) {
                // Your error handling here
            }
            else {
                results = objects as NSArray
                completion(returnValue:results)
                
                //NSLog("Result: \(result) ")
                println("===================")
                
                for (var i=0; i<results.count; i++)
                {
                    //println(results[i]["avgRank"] as Int)
                    println(results[i]["category"] as String)
                    //println(results[i]["description"] as String)
                    //println(results[i]["location"] as PFGeoPoint)
                    //println(results[i]["name"] as String)
                    //println(results[i]["numRankings"] as Int)
                    //println(results[i]["userID"] as PFUser)
                }
                
                
            }
        }
    }

    /**
    * Attempts to register a new user.  To be used when user does not wish to link his/her facebook profile.
    * Takes 4 parameters:
    *      user - A username to register with.  This MUST be unique.
    *      pass - A password the user creates.
    *      email - The user's email.  This MUST be unique.
    *      name - The user's name.
    * Example: {"user":"Foo", "pass":"pw", "email":"thisisalecwu@gmail.com", "name":"ALEC"}
    */
    func newUserSignup(username:String, password:String, email: String, fullname: String)-> String {
        var s = String()

        //PFCloud.callFunctionInBackground("newUserSignup", withParameters: ["user":"Username", "pass":"password", "email":"Username@gmail.com", "name":"fullname"]) {
        PFCloud.callFunctionInBackground("newUserSignup", withParameters: ["user":username, "pass":password, "email":email, "name":fullname]) {
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
    * Attempts to register a new user via Facebook.  The user logs in via the app, which will then save the results of a successful login to Parse.
    * Takes 3 params:
    *      fbID - User's Facebook Id.
    *      email - User's Email
    *      name - User's name
    * Example: {"fbID":"392874928", "email":"fastily@yahoo.com", "name":"Fastily"}
    */
    func fbSignup(fbID:String, email:String, fullname:String)-> String {
        var s = String()
        //PFCloud.callFunctionInBackground("fbSignup", withParameters: ["fbID":"392874928", "email":"fastily@yahoo.com", "name":"Fastily"]) {
        PFCloud.callFunctionInBackground("fbSignup", withParameters: ["fbID":fbID, "email":email, "name":fullname]) {
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
    
    func emailRegistered(email:String)-> Bool {
        var s = Bool()
        //PFCloud.callFunctionInBackground("emailRegistered", withParameters: ["email":"fastily@yahoo.com"]) {
        PFCloud.callFunctionInBackground("emailRegistered", withParameters: ["email":email]) {
            (objects: AnyObject!, error: NSError!) -> Void in
            var results = []
            if (error != nil) {
                // Your error handling here
                s = true
            }
            else {
                
                s = false
                
            }
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

    /**
    * Attempts to send a password reset email.
    * Takes one param:
    *      email - the email to send the password reset.
    * Example: '{"email":"fastily@yahoo.com"}'
    */
    func resetPasswordRequest(email:String)-> String {
        var s = String()
        //PFCloud.callFunctionInBackground("resetPasswordRequest", withParameters: ["email":"fastily@yahoo.com"]) {
        PFCloud.callFunctionInBackground("resetPasswordRequest", withParameters: ["email":email]) {
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
    * Gets a user's Score entry.
    * Takes one param:
    *      user - The unique username of the user to get Score entries for.
    * Example: {"user":"Admin"}
    */
    func getUserScore(username:String)-> Float {
        var s = Float()
        //PFCloud.callFunctionInBackground("getUserScore", withParameters: ["username":"Admin"]) {
        PFCloud.callFunctionInBackground("getUserScore", withParameters: ["username":username]) {
            (objects: AnyObject!, error: NSError!) -> Void in
            var results = []
            if (error != nil) {
                // Your error handling here
            }
            else {
                s = objects as Float
            }
        }
        return s
    }

    /**
    * Get the number of event votes for a given event.
    * Takes one param:
    *      obj - The unique objectId of the Event object we're trying to get votes for.
    * Example: {"obj":"CWwv1FzgPh"}
    */
    func countEventVotes(objID:String)-> Int {
        var s = Int()
        //PFCloud.callFunctionInBackground("countEventVotes", withParameters: ["obj":"CWwv1FzgPh"]) {
        PFCloud.callFunctionInBackground("countEventVotes", withParameters: ["obj":objID]) {
            (objects: AnyObject!, error: NSError!) -> Void in
            var results = []
            if (error != nil) {
                // Your error handling here
            }
            else {
                s = objects as Int
            }
        }
        return s
    }

    /**
    * Gets Events in descending (most recent first).
    * Takes 2 OPTIONAL params:
    *      limit - limit the maximum number of items returned
    *      skip - Skip this many items before returning items.  Useful for pagination.
    * Example: {"limit":3, "skip":1}
    */
    func getEvents(limit:Int, skip:Int)->AnyObject {
        
        //For a Non-Blocking Call Comment out below
        /*PFCloud.callFunctionInBackground("getEvents", withParameters: ["limit":limit, "skip":skip]) {
            (objects: AnyObject!, error: NSError!) -> Void in
            var result = []
            if (error != nil) {
                // Your error handling here
            }
            else {
                result = objects as NSArray

                completion(returnValue:result)
                /*
                //NSLog("Result: \(result) ")
                println("===================")
                
                for (var i=0; i<result.count; i++)
                {
                println(result[i]["avgRank"] as Int)
                println(result[i]["category"] as String)
                println(result[i]["description"] as String)
                println(result[i]["location"] as PFGeoPoint)
                println(result[i]["name"] as String)
                println(result[i]["numRankings"] as Int)
                println(result[i]["userID"] as PFUser)
                }
                */
                
            }
        }*/
        
        //This is a blocking call, will stall the main thread
        let result: AnyObject! = PFCloud.callFunction("getEvents", withParameters: ["limit":limit, "skip":skip])
        return result;
        
    }

    /**
    * Lookup an event by coordinate.
    * Takes 2 params:
    *      lat - Double - The latitude of the coordinate.
    *      long - Double - The longitude of the coordinate.
    * Example: {"lat":32.883192, "lon":-117.240933}
    */
    func lookupEventByCoord(lat:Double, long:Double)->AnyObject {
        
        let result: AnyObject! = PFCloud.callFunction("lookupEventByCoord", withParameters: ["lat":lat, "long":long])
        return result;
    }

    /**
    * Lookup a Location by coordinate.
    * Takes 2 params:
    *      lat - Double - The latitude of the coordinate.
    *      long - Double - The longitude of the coordinate.
    * Example: {"lat":32.883192, "lon":-117.240933}
    */
    func lookupLocationByCoord(lat:Double, long:Double)->AnyObject {
        
        let result: AnyObject! = PFCloud.callFunction("lookupLocationByCoord", withParameters: ["lat":lat, "long":long])
        return result;
    }
    
    /**
    * Get event comments for an event.
    * Takes 3 params:
    *      limit (OPTIONAL) - limit the maximum number of items returned
    *      skip (OPTIONAL) - Skip this many items before returning items.  Useful for pagination.
    * Example: {"limit":3, "skip":1, "obj":"CWwv1FzgPh"}
    */
    func getEventComments(objID:String, limit:Int, skip:Int)->AnyObject {
        /*
        PFCloud.callFunctionInBackground("getEventComments", withParameters: ["limit":limit, "skip":skip, "obj":objID]) {
            (objects: AnyObject!, error: NSError!) -> Void in
            var result = []
            if (error != nil) {
                // Your error handling here
            }
            else {
                result = objects as NSArray
                completion(returnValue:result)
                
            }
        }
        */
        let result: AnyObject! = PFCloud.callFunction("getEventComments", withParameters: ["limit":limit, "skip":skip, "obj":objID])
        return result;
    }
    
    /**
    * Posts a new EventCmt.
    * Takes 3 params:
    *      comment - The comment
    *      user - The user's username
    *      target - The objectId of the event to post for.
    *  Example: {"comment":"yolo", "user":"Admin", "objectId": "CWwv1FzgPh"}
    */
    func postEventCmt(comment:String, user:String, objectId:String)-> String {
        var s = String()
        //PFCloud.callFunctionInBackground("postEventCmt", withParameters: ["comment":"yolo", "user":"Admin", "objectId": "CWwv1FzgPh"]) {
        PFCloud.callFunctionInBackground("postEventCmt", withParameters: ["comment":comment, "user":user, "objectId": objectId]) {
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

    /**
    * Post a new LocationRank.
    * Takes 4 params:
    *      user - String - the creator's username
    *      rating - Integer - The user's rating of the location, out of 5.
    *      review - String - The The user's review of the location.
    *      target - String - The unique objectId of the Location object this LocationRank is referencing.
    *  Example: {"user":"Admin", "rating": 4, "review":"This place is rad", "target":"gM2X4HWgXe"}
    */
    func postLocationRank(user:String, rating:String, review:String, target:String)-> String {
        var s = String()
        //PFCloud.callFunctionInBackground("postLocationRank", withParameters: ["user":"Admin", "rating": 4, "review":"This place is rad", "target":"gM2X4HWgXe"]) {
        PFCloud.callFunctionInBackground("postLocationRank", withParameters: ["user":user, "rating": rating, "review":review, "target":target]) {
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
    * Post a new Location.
    * Takes 6 params:
    *      user - String - the creator's username
    *      name - String - The name of the location.
    *      desc - String - A description of the location
    *      lat - Number - The event's latitude.
    *      lon - Number - The event's longitude.
    *      cat - String - This item's category.
    *  Example: {"user":"Admin", "name": "TESTLOCATION", "desc":"Some test location", "lat":32, "lon":-117, "cat":"bar"}
    */
    func postLocation(user:String, name:String, desc:String, category:String)-> String {
        var s = String()
        //PFCloud.callFunctionInBackground("postLocation", withParameters: ["user":"Admin", "name": "TESTLOCATION", "desc":"Some test location", "lat":32, "lon":-117, "cat":"bar"]) {
        PFCloud.callFunctionInBackground("postLocation", withParameters: ["user":user, "name": name, "desc":desc, "lat":32, "lon":-117, "cat":category]) {
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
                obj.saveInBackground()
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
        var user = PFUser.logInWithUsername(username, password: password);

        return user
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
                user.saveInBackground()
                
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
