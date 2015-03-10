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
    ///:returns: A Score object with the user's score info as a PFObject.
    public class func getUserScore(username:String) -> PFObject
    {
        return (PFCloud.callFunction("getUserScore", withParameters: ["user":username]))! as PFObject
    }
}