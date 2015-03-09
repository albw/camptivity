//
//  ParseUser.swift
//  Camptivity
//
//  Created by Alec Wu on 3/7/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import Foundation
import Parse


public class ParseUser
{
    /// Register a new user. To be used when user does not wish to link his/her facebook profile.
    ///
    /// :param: username The username to create this account with.  This *MUST* be unique.
    /// :param: password The user's password
    /// :param: email The unique email to register this account with
    /// :param: fullname The user's name
    ///:returns: A tuple, where the first element indicates whether the operation was successful, and the second operation is the log message.
    public class func newUserSignup(username:String, password:String, email: String, fullname: String)-> (Bool, String) {
        
        var e : NSError?
        var x : AnyObject! = PFCloud.callFunction("newUserSignup", withParameters: ["user":username, "pass":password, "email":email, "name":fullname], error: &e)
        
        return (e != nil ? false : true, x as String!)
    }
    
    
    /// Attempts to register a new user via Facebook.  The user logs in via the app, which will then save the results of a successful login to Parse.
    ///
    ///:param: fbID The user's facebook id
    ///:param: email The user's email, retrieved from Facebook
    ///:param: fullname The user's full name, retrieved from Facebook.
    ///:returns: A tuple, where the first element indicates whether the operation was successful, and the second operation is the log message.
    public class func fbSignup(fbID:String, email:String, fullname:String)-> (Bool, String) {
        var e: NSError?
        var x: AnyObject! = PFCloud.callFunction("fbSignup", withParameters: ["fbID":fbID, "email":email, "name":fullname], error: &e)
        return (e != nil ? false : true, x as String!)
    }
    
    /// Attempts to send a password reset email.
    ///
    ///:param: email The user's email to reset.
    ///:returns: True if the operation was successful
    public class func resetPasswordRequest(email:String)-> Bool {
        var e: NSError?
        var x: AnyObject! = PFCloud.callFunction("resetPasswordRequest", withParameters: ["email":email], error: &e)
        return e != nil ? false : true
    }
}