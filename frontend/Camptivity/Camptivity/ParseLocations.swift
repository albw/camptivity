//
//  ParseLocations.swift
//  Camptivity
//
//  Created by Alec Wu on 3/7/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import Foundation
import Parse

public class ParseLocations
{
    /// Lookup a Location by its coordinates.  WARNING: THIS IS SEVERELY BROKEN BECAUSE OF THE WAY FLOATING POINT ARITHMETIC WORKS.  WE NEED TO REDESIGN LOCATION LOOKUP.
    ///
    ///:param: lat The latitude
    ///:param: lon The longitude
    ///:returns: The Location we found as a PFObject
    public class func lookupLocationByCoord(lat:String, lon:String)->PFObject {
        return (PFCloud.callFunction("lookupLocationByCoord", withParameters: ["lat":lat, "lon":lon]))! as PFObject
    }
    
    /// Post a LocationRank for a Location
    ///
    ///:param: user The username performing the post
    ///:param: rating The user's rating, out of 5
    ///:param: review The user's review
    ///:param: objId The objectId of the Location to post a LocationRank for
    ///:returns: True if we were successful.
    public class func postLocationRanks(user:String, rating:Int, review:String, objId:String) -> Bool {
        var e :NSError?
        PFCloud.callFunction("postLocationRank", withParameters: ["user":user, "review":review, "rating":rating, "target": objId], error: &e)
        return e != nil ? false : true
        
        
    }
}