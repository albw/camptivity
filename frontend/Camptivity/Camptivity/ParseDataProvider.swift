//
//  ParseDataProvider.swift
//  Camptivity
//
//  Created by SI  on 2/12/15.
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
    

    
    func fetchLocationsNearMe(completion: (returnValue: [AnyObject])->Void) {
        PFCloud.callFunctionInBackground("locationsNearMe", withParameters: ["category":"restroom","lat":32.88293263160078,"lon":-117.2109485336882,"radius":40]) {
            (objects: AnyObject!, error: NSError!) -> Void in
            var results = []
            if (error != nil) {
                // Your error handling here
            }
            else {
                results = objects as NSArray
                completion(returnValue:results)
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

    func newUserSignup()-> String {
        var s = String()
        PFCloud.callFunctionInBackground("newUserSignup", withParameters: ["user":"Username", "pass":"password", "email":"Username@gmail.com", "name":"fullname"]) {
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

    func emailRegistered()-> Bool {
        var s = Bool()
        PFCloud.callFunctionInBackground("emailRegistered", withParameters: ["email":"fastily@yahoo.com"]) {
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


    func usernameTaken()-> Bool {
        var s = Bool()
        PFCloud.callFunctionInBackground("usernameTaken", withParameters: ["username":"Admin"]) {
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

    func resetPasswordRequest()-> String {
        var s = String()
        PFCloud.callFunctionInBackground("resetPasswordRequest", withParameters: ["email":"fastily@yahoo.com"]) {
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

    
}
