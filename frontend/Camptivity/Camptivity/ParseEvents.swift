//
//  ParseEvents.swift
//  Camptivity
//
//  Created by Alec Wu on 3/7/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import Foundation
import Parse

public class ParseEvents
{
    /// Get Events, ordered by most recent first.
    ///
    ///:param: limit The maximium number of elements to return (max = 1k)
    ///:param: skip The maximium number of elements to skip/paginate (max = 10k)
    ///:returns: A list of Events as PFObjects
    public class func getEvents(limit:Int = 1000, skip:Int = 0)->[PFObject] {
        return (PFCloud.callFunction("getEvents", withParameters: ["limit":limit, "skip":skip]))! as [PFObject]

    }
    
    /// Count event votes for any given event
    ///
    ///:param: objId The objectId of the Event to get a count for.
    ///:returns: The number of votes for this Event.
    public class func countEventVotes(objId: String) -> Int {
        return (PFCloud.callFunction("countEventVotes", withParameters: ["obj": objId]))! as Int
    }
    
    /// Lookup an event by its coordinates.  WARNING: THIS IS SEVERELY BROKEN BECAUSE OF THE WAY FLOATING POINT ARITHMETIC WORKS.  WE NEED TO REDESIGN OUR INTERFACE
    ///
    ///:param: lat The latitude
    ///:param: lon The longitude
    ///:returns: The Event we found as a PFObject
    public class func lookupEventByCoord(lat:Double, lon:Double)->PFObject {
        return (PFCloud.callFunction("lookupEventByCoord", withParameters: ["lat":lat, "lon":lon]))! as PFObject
    }
    

    /// Get EventCmts for an Event
    ///
    ///:param: objId The objectId of the Event to get EventCmts for
    ///:param: limit The maximium number of elements to return (max = 1k)
    ///:param: skip The maximium number of elements to skip/paginate (max = 10k)
    ///:returns: A list of EventCmts
    public class func getEventComments(objId: String, limit:Int = 1000, skip:Int = 0) -> [PFObject] {
        return (PFCloud.callFunction("getEventComments", withParameters: ["limit":limit, "skip":skip, "obj":objId]))! as [PFObject]
    }
    
    /// Post an EventCmt for a User
    ///
    ///:param: objId The objectId of the Event to post an EventCmt for
    ///:param: comment The comment
    ///:param: user The username performing the post (case-sensitive)
    ///:returns: True if we were successful.
    public class func postEventComment(objId:String, comment:String, user:String) -> Bool {
        var e: NSError?
        PFCloud.callFunction("postEventCmt", withParameters: ["comment":comment, "user":user, "objectId": objId], error: &e)
        return e != nil ? false : true
        
    }
    
    
}