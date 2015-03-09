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
        var p = ParseUser.newUserSignup("TESTUSER", password: "BLAH", email: "fastily@yahoo.com", fullname: "AWU")
        println(p.0)
        println(p.1)
        
        XCTAssert(p.0, "Pass")
    }
    
    func testFBSignup()
    {
        var p = ParseUser.fbSignup("69696969696", email: "fastily@yahoo.com", fullname: "AWU")
        println(p.0)
        println(p.1)
        XCTAssert(p.0, "Pass")
    }
    
    func testResetPasswordRequest()
    {
        XCTAssert(ParseUser.resetPasswordRequest("fastily@yahoo.com"), "Pass")
    }
    
    
    func testGetUserScore()
    {
        var p = ParseScore.getUserScore("fastily@yahoo.com")
        
        println(p)
        //for z in p
         // println(z)
        
        //println(p)
        //println(p.dynamicType)
        XCTAssert(true, "Pass")
    }
    
    
    func testGetEvents()
    {
        var p = ParseEvents.getEvents(limit: 2, skip: 1)
        println(p)
        
        XCTAssert(true, "Pass")
    }
    
    
    func testCountEventVotes()
    {
        var p = ParseEvents.countEventVotes("CWwv1FzgPh")
        println(p)
        XCTAssert(true, "Pass")        
        
    }
    
    //{"lat":32.883192, "lon":-117.240933}
    func testLookupEventByCoord()
    {
        var p = ParseEvents.lookupEventByCoord(32.883192, lon: -117.240933)
        println(p)
        
        XCTAssert(true, "Pass")
    }
    
    func testLookupLocationByCoord()
    {
        var p = ParseLocations.lookupLocationByCoord("32.880361", lon: "-117.233438")
        println(p)
        
        XCTAssert(true, "Pass")
    }
    
    func testGetEventComments()
    {
        var p = ParseEvents.getEventComments("CWwv1FzgPh", limit: 3)
        println(p)
        
        XCTAssert(true, "Pass")
    }
    
    func testPostEventComment()
    {
        XCTAssert(ParseEvents.postEventComment("YRyEAFRzUH", comment:"Sup bitches", user:"Admin"), "Pass")
    }
    
    func testPostLocationRank()
    {
       XCTAssert( ParseLocations.postLocationRanks("Admin", rating:2, review:"This shit sux", objId:"vWRWYBwnYJ"), "Pass")
    }

}
