//
//  ParseScore.swift
//  Camptivity
//
//  Created by Alec Wu on 3/7/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import Foundation
import Parse

public class ParseScore
{
    public func getUserScore(username:String) -> [PFObject]
    {
        var e: NSError?
        //println("BOO")
        var x: [PFObject]! = PFCloud.callFunction("getUserScore", withParameters: ["username":username], error:&e) as [PFObject]
       // println(x)
        
        return x
        
    }

}