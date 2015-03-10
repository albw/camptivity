import UIKit
import XCTest

/// Camptivity Unit Tests!
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
        println(ParseScore.getUserScore("Admin"))
        XCTAssert(true, "Pass")
    }
    
    
    func testGetEvents()
    {
        println(ParseEvents.getEvents(limit: 2, skip: 1))
        XCTAssert(true, "Pass")
    }
    
    
    func testCountEventVotes()
    {
        println(ParseEvents.countEventVotes("CWwv1FzgPh"))
        XCTAssert(true, "Pass")
    }
    
    func testGetEventComments()
    {
        println(ParseEvents.getEventComments("CWwv1FzgPh", limit: 3))
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
    
    
    func testPostEvent()
    {
        XCTAssert(ParseEvents.postEvent("Some dope event", desc: "totally rad!", lat: 33.0, lon: -117.09, user: "Admin", start: "2015-03-21T18:02:52.249Z", expires: "2015-03-22T18:02:52.249Z"), "Pass")
    }
    
    
    func testGetLocationByName(){
        println(ParseLocations.getLocationByName("P206"))
        XCTAssert(true, "Pass")
    }
    
    
    func testGetEventByName(){
        println(ParseEvents.getEventByName("Test4"))
        XCTAssert(true, "Pass")
    }
    
    
    func testGetLocationRankForLocation() {
        println(ParseLocations.getLocationRankForLocation("vWRWYBwnYJ"))
        XCTAssert(true, "Pass")
    }
    
    func testPostEventVote() {
        XCTAssert(ParseEvents.postEventVote("Admin", objId: "CWwv1FzgPh", isUpVote: false), "Pass")
        
    }
}
