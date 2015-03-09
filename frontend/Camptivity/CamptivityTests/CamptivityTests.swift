//
//  CamptivityTests.swift
//  CamptivityTests
//
//  Created by Shayan Mahdavi on 1/25/15.
//  Copyright (c) 2015 Shayan Mahdavi. All rights reserved.
//

import UIKit
import XCTest

class CamptivityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNewUserSignup()
    {
        var p = ParseUser().newUserSignup("TESTUSER", password: "BLAH", email: "fastily@yahoo.com", fullname: "AWU")
        println(p.0)
        println(p.1)
        
        XCTAssert(p.0, "Pass")
    }
    
    func testFBSignup()
    {
        var p = ParseUser().fbSignup("69696969696", email: "fastily@yahoo.com", fullname: "AWU")
        println(p.0)
        println(p.1)
        XCTAssert(p.0, "Pass")
    }
    
    func testResetPasswordRequest()
    {
        var p = ParseUser().resetPasswordRequest("fastily@yahoo.com")
        XCTAssert(p, "Pass")
    }
    
    
    func testGetUserScore()
    {
        var p = ParseScore().getUserScore("fastily@yahoo.com")
        
        //for z in p
         // println(z)
        
        //println(p)
        //println(p.dynamicType)
        XCTAssert(true, "Pass")
    }
    
    
    /*
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }*/
    
}
