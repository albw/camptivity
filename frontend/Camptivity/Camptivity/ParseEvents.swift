//
//  ParseEvents.swift
//  Camptivity
//
//  Created by Alec Wu on 3/7/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import Foundation
import Parse

/// This class contains methods which can get/set data for Event, EventCmt, and EventVote objects
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
    
    ///Post a new Event object
    ///
    ///:param: name The name of the event
    ///:param: desc The Event description
    ///:param: lat The latitude
    ///:param: lon The longitude
    ///:param: user The user performing the create
    ///:param: start The start date. A date/time in ISO 8601, UTC (e.g. "2011-08-21T18:02:52.249Z")
    ///:param: end The end date. A date/time in ISO 8601, UTC (e.g. "2011-08-21T18:02:52.249Z")
    ///:returns: True if we were successful.
    public class func postEvent(name:String, desc:String, lat:Double, lon:Double, user:String, start:String, expires:String) -> Bool {
        var e: NSError?
        PFCloud.callFunction("postEvent", withParameters: ["name":name, "desc":desc, "lat": lat, "lon":lon, "user":user, "start":start, "expires":expires], error: &e)
        return e != nil ? false : true
    }
    
    /// Get an Event by name
    ///
    ///:param: name The unique name of the Event (case-sensitive)
    ///:returns: The Event as a PFObject.
    public class func getEventByName(name:String) -> PFObject {
        return Utils.entryWhere("Events", col: "name", value: name)
    }
}