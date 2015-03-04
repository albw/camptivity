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
            }
            else {
                
                s = objects as Bool
                
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


    func getEvents(limit:Int, skip:Int, completion: (returnValue: [AnyObject])->Void) {
        //PFCloud.callFunctionInBackground("getEvents", withParameters: ["limit":3, "skip":1]) {
        PFCloud.callFunctionInBackground("getEvents", withParameters: ["limit":limit, "skip":skip]) {
            (objects: AnyObject!, error: NSError!) -> Void in
            var result = []
            if (error != nil) {
                // Your error handling here
            }
            else {
                result = objects as NSArray

                //completion(returnValue:result)
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
        }
    }

    func getEventComments(objID:String, limit:Int, skip:Int, completion: (returnValue: [AnyObject])->Void) {
        //PFCloud.callFunctionInBackground("getEventComments", withParameters: ["limit":3, "skip":1, "obj":"CWwv1FzgPh"]) {
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
    }
    
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
