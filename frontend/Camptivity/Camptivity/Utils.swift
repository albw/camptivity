//
//  Utils.swift
//  Camptivity
//
//  Created by Alec Wu on 3/8/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import Foundation
import Parse

/// This class contains methods which contain supporting utility methods for Model.
public class Utils
{
    /// Grabs first row of a table where a given column is equal to a specific value.
    ///
    ///:param: table The name of the table to query
    ///:param: col The name of the column to query
    ///:param: value The value to check against in col
    ///:returns: The PFObject we found, or nil if there was nothing.
    public class func entryWhere(table:String, col:String, value:AnyObject) -> PFObject {
        return PFQuery(className: table).whereKey(col, equalTo: value).getFirstObject()
    }
}