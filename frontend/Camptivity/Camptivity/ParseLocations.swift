//
//  ParseLocations.swift
//  Camptivity
//
//  Created by Alec Wu on 3/7/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import Foundation
import Parse

/// This class contains methods which can get/set data for Location and LocationRank objects
public class ParseLocations
{
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
    
    
    /// Get a Location by name
    ///
    ///:param: name The unique name of the location (case-sensitive)
    ///:returns: The Location as a PFObject.
    public class func getLocationByName(name:String) -> PFObject {
        return Utils.entryWhere("Locations", col: "name", value: name)
    }
    
    /// Get LocationRanks for a Location
    ///
    ///:param: objectId The unique objectId of the Location to fetch LocationRanks for
    ///:returns: The LocationRanks for this Location.
    public class func getLocationRankForLocation(objectId:String) -> [PFObject] {
        return (PFCloud.callFunction("getLocationRanks", withParameters: ["objid":objectId]))! as [PFObject]
    }
    
    /// Get locations nearby a coordinate
    ///
    ///:param: category A list of categories to select.  Any location in this list with the specified category can be returned.
    ///:param: lat The latitude of the GeoPoint to select
    ///:param: lon The longitude of the GeoPoint to select
    ///:param: radius The maximum radius, in miles, to search around the specified GeoPoint.  Default is 5 miles.
    ///:returns: A list of PFObjects we found.
    public class func getLocationsNearMe(category:[String], lat:Double, lon:Double, radius:Double=5) -> [PFObject] {
        return (PFCloud.callFunction("locationsNearMe", withParameters: ["category":category, "lat":lat, "lon":lon, "radius":radius]))! as [PFObject]
    }
}