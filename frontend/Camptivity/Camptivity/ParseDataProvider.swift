//
//  ParseDataProvider.swift
//  Camptivity
//
//  Created by SI  on 2/12/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//


class ParseDataProvider {
    
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
    
    
    
    
}
