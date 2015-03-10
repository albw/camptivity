//
//  ParseScore.swift
//  Camptivity
//
//  Created by Alec Wu on 3/7/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import Foundation
import Parse

/// This class contains methods which can get/set data for Score objects.
public class ParseScore
{
    /// Get user score fields.
    ///
    ///:param: username Get score data for this user
    ///:returns: A dictionary with the following keys: eventComments, eventsCreated, locationsRanked, votesGiven, votesReceived.
    public class func getUserScore(username:String) -> [String:Int]
    {
        var o = PFQuery(className: "Score").whereKey("userID", equalTo: Utils.entryWhere("_User", col: "username", value: username)).getFirstObject()
        
        var l = [String:Int]()
        l["eventComments"] = o.objectForKey("eventComments") as? Int
        l["eventsCreated"] = o.objectForKey("eventsCreated") as? Int
        l["locationsRanked"] = o.objectForKey("locationsRanked") as? Int
        l["votesGiven"] = o.objectForKey("votesGiven") as? Int
        l["votesReceived"] = o.objectForKey("votesReceived") as? Int

        return l
    }

}