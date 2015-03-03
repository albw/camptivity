var Events = require("cloud/Events.js");
var Locations = require("cloud/Locations.js");
var Score = require("cloud/Score.js");
var Users = require("cloud/Users.js");

/* //////////////////////////////////////////////////////////////////////////////// */
/* /////////////////////////// INTERNAL STANDBY /////////////////////////////////// */
/* //////////////////////////////////////////////////////////////////////////////// */

/**
 * Performs initialization tasks for a new user:
 * 1) Create a blank score row for user
*/
Parse.Cloud.afterSave("_User", function(request) {
	if(!request.object)
		console.log("Looks like we had an issue: " + JSON.stringify(request, null, 4));
	else if(!request.object.existed()) {
		var Score = Parse.Object.extend("Score");
		var sc = new Score();
		sc.save({userID: request.object, votesGiven: 0, votesReceived: 0, eventComments: 0, locationTags: 0}).then(function(meh) {
			console.log("Set-up score row for a new user!");
		});
	} 
});

/**
 * Auto-sets numRankings and avgRank to 0 when new Locations object is created.
 */
 Parse.Cloud.afterSave("Locations", function(request) {
 	if(!request.object)
 		console.log("Looks like we had an issue: " + JSON.stringify(request, null, 4));
 	else if(!request.object.existed())
 		request.object.save({numRankings: 0, avgRank: 0}).then(function(meh) {
 			console.log("Logged creation of new location object: " + request.object.get("name"));
 		});
 });


/**
 * Increments a field in the Score table for a given user.
 * Takes two params - userId: pointer to the user's whos entry we'll be incrementing
 * 				      item: a string naming the column to increment.
 */
 function incScoreField(userId, item) {
 	return new Parse.Query("Score").equalTo("userID", userId).first().then(function(obj) {
 		obj.increment(item);
 		return obj.save();
 	});
 }


/**
 * Performs following functions: 
 * 1) Re-computes the average for the Locations object referenced by this LocationRank. 
 * 2) Increment user's locationTags in Score table by one.
*/ 
Parse.Cloud.afterSave("LocationRank", function(request) {
	if(request.object && !request.object.existed())
		new Parse.Query("Locations").get(request.object.get("target").id, {
			success: function(meh) {
				meh.set("avgRank", (meh.get("numRankings") * meh.get("avgRank") + request.object.get("rating"))/(meh.get("numRankings") + 1));
				meh.increment("numRankings");
				meh.save().then(function(blah) {
					console.log("Updated average of " + meh.get("name"));

					incScoreField(meh.get("userID"), "locationTags").then(function(asdf) {
						console.log("Incremented location review score for " + asdf.get("userID").id);
					});
				});
			},
			error: function(ex) {
				console.log("Error running afterSave on LocationRank: " + JSON.stringify(ex, null, 4 ));
			}
		});
});


/**
 * When an EventVotes is cast:
 * 1) Increment the likesReceived score for user who created the event.
 * 2) Increment the likesGiven score for the user who voted.
*/
Parse.Cloud.afterSave("EventVotes", function(request) {
	if(request.object && !request.object.existed())
		incScoreField(request.object.get("userID"), "votesGiven").then(function(asdf){
			console.log("Incremented votesGiven score for " + asdf.get("userID").id);

			new Parse.Query("Events").get(request.object.get("target").id, {
				success: function(obj) {
					incScoreField(obj.get("userID"), "votesReceived").then(function(meh) {
						console.log("Incremented votesReceived score for " + obj.get("userID").id);
					});
				},
				error: function(err) {
					console.log("Error running afterSave on EventVotes: " + JSON.stringify(err, null, 4 ));
				}
			});
		});
});


/**
 * Increment the event comment score for a user when they create a comment.
 */
Parse.Cloud.afterSave("EventCmt", Score.incEventCmtScore);


/* //////////////////////////////////////////////////////////////////////////////// */
/* /////////////////////////////////// JOBS /////////////////////////////////////// */
/* //////////////////////////////////////////////////////////////////////////////// */

/**
 * Goes through the Events table and drops rows with expired events.
 */
 Parse.Cloud.job("nukeDeadEvents", Events.nukeDeadEvents);


 /* //////////////////////////////////////////////////////////////////////////////// */
 /* /////////////////////////// CLOUD FUNCTIONS //////////////////////////////////// */
 /* //////////////////////////////////////////////////////////////////////////////// */

/**
 * Attempts to register a new user.  To be used when user does not wish to link his/her facebook profile. 
 * Takes 4 parameters:
 *		user - A username to register with.  This MUST be unique.
 *		pass - A password the user creates.
 *		email - The user's email.  This MUST be unique.
 *		name - The user's name.
 * Example: {"user":"Foo", "pass":"pw", "email":"thisisalecwu@gmail.com", "name":"ALEC"}
 */
 Parse.Cloud.define("newUserSignup", Users.newUserSignup);

/**
 * Attempts to register a new user via Facebook.  The user logs in via the app, which will then save the results of a successful login to Parse.
 * Takes 3 params:
 *		fbID - User's Facebook Id.
 *		email - User's Email
 *		name - User's name
 * Example: {"fbID":"392874928", "email":"fastily@yahoo.com", "name":"Fastily"}
 */
Parse.Cloud.define("fbSignup", Users.fbSignup);

/**
 * Attempts to send a password reset email.
 * Takes one param:
 * 		email - the email to send the password reset.
 * Example: '{"email":"fastily@yahoo.com"}'
 */
 Parse.Cloud.define("resetPasswordRequest", Users.resetPasswordRequest);

/**
 * Identifies locations near a GeoPoint in a specific category. Restricted by radius (miles). 
 * Takes 4 params: 
 *		category - The String category/categories to select.  This is a String array.
 *		lat - The latitude of the GeoPoint to select.
 *		long - The longditude of the GeoPoint to select.
 * 		radius - The radius to search from the specified GeoPoint, in Miles.
 * Example: {"category":["restroom", "bar"], "lat":30, "lon:"30, "radius":40}
 */
 Parse.Cloud.define("locationsNearMe", Locations.locationsNearMe);

/**
 * Gets a user's Score entry.
 * Takes one param:
 * 		user - The unique username of the user to get Score entries for.
 * Example: {"user":"Admin"}
 */
 Parse.Cloud.define("getUserScore", Score.getUserScore);

/**
 * Gets LocationRanks for the specified Locations object.
 * Takes one param:
 *		objid - The unique objectId of the Location we're trying to get locationRanks for.
 * Example: {"objid":"d70IYXni4G"}
 */
 Parse.Cloud.define("getLocationRanks", Locations.getLocationRanks);

/**
 * Get the number of event votes for a given event.
 * Takes one param:
 * 		obj - The unique objectId of the Event object we're trying to get votes for.
 * Example: {"obj":"CWwv1FzgPh"}
 */
Parse.Cloud.define("countEventVotes", Events.countEventVotes);

/**
 * Gets Events in descending (most recent first).  
 * Takes 2 OPTIONAL params: 
 * 		limit - limit the maximum number of items returned
 *		skip - Skip this many items before returning items.  Useful for pagination.
 * Example: {"limit":3, "skip":1}
 */
Parse.Cloud.define("getEvents", Events.getEvents);

/**
 * Get event comments for an event.
 * Takes 3 params: 
 * 		limit (OPTIONAL) - limit the maximum number of items returned
 *		skip (OPTIONAL) - Skip this many items before returning items.  Useful for pagination.
 * Example: {"limit":3, "skip":1, "obj":"CWwv1FzgPh"}
 */
Parse.Cloud.define("getEventComments", Events.getEventComments);

/**
 * Posts a new EventCmt.
 * Takes 3 params:
 *		comment - The comment
 *		user - The user's username
 *		target - The objectId of the event to post for.
 *	Example: {"comment":"yolo", "user":"Admin", "objectId": "CWwv1FzgPh"}
 */
Parse.Cloud.define("postEventCmt", Events.postEventCmt);
