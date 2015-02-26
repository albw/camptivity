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
					console.log("Error running afterSave on EventVotes: " + JSON.stringify(ex, null, 4 ));
				}
			});
		});
});


/**
 * Increments the event comment score for a user when they create a comment.
 */
Parse.Cloud.afterSave("EventCmt", function(request) {
	if(request.object && !request.object.existed())
 		incScoreField(request.object.get("userID"), "eventComments").then(function(asdf){
 			console.log("Incremented event comment score for: " + asdf.get("userID").id);
 		});
});


/* //////////////////////////////////////////////////////////////////////////////// */
/* /////////////////////////////////// JOBS /////////////////////////////////////// */
/* //////////////////////////////////////////////////////////////////////////////// */

/**
 * Internal job that goes through Events table and deletes all expired events.
 */
 Parse.Cloud.job("nukeDeadEvents", function(request, status) {
 	Parse.Cloud.useMasterKey();
 	new Parse.Query(Parse.Object.extend("Events")).lessThan("expires", new Date()).find({
 		success: function(results) {
 			Parse.Object.destroyAll(results).then(function(meh) {
 				status.success("Job completed: " + results.length + " old event(s) pruned");
 			});
 		},
 		error: function(error) {
 			status.error("Failed to nuke old events: " + error.message);	
 		}
 	});
 });


 /* //////////////////////////////////////////////////////////////////////////////// */
 /* /////////////////////////// CLOUD FUNCTIONS //////////////////////////////////// */
 /* //////////////////////////////////////////////////////////////////////////////// */


/**
 * Attempts to register a new user.  This method shall be applied in the use case where the user does not wish to link
 * his/her facebook profile. 
 * Takes the following four String parameters: user, pass, email, name.
 * Example: {"user":"Foo", "pass":"pw", "email":"thisisalecwu@gmail.com", "name":"ALEC"}
 */
 Parse.Cloud.define("newUserSignup", function(request, response) {
 	Parse.Query.or(new Parse.Query("_User").equalTo("username", request.params.user), 
 		new Parse.Query("_User").equalTo("email", request.params.email)).first().then(function(result) {
 			if(!result) 
 				Parse.User.signUp(request.params.user, request.params.pass, {email: request.params.email, name: request.params.name}, {
 					success: function(ux) {
 						response.success("Signed up a new user: " + ux.get("username"));
 					},
 					error: function(meh) {
 						response.error("Failed to run newUserSignup task: " + JSON.stringify(meh, null, 4));
 					}
 				});
 			else
 				response.error("Username/Email has already been taken!")
 		});
 	});


/**
 * Attempts to register a new user via Facebook.  The user shall login in the app, which will then pass the results of a successful login.
 * Takes the following 3 params: fbID, email, and name.
 * Example: {"fbID":"392874928", "email":"fastily@yahoo.com", "name":"Fastily"}
 */
Parse.Cloud.define("fbSignup", function(request, response) {
	new Parse.Query("_User").equalTo("fbID", request.params.fbID).first().then(function(result){
		if(!result)
			Parse.User.signUp(request.params.email, "" + Math.random(), {email: request.params.email, name: request.params.name, fbID: request.params.fbID}, {
				success: function(ux) {
					response.success("Registered a new user via FB: " + ux.get("name") + " @ " + ux.get("fbID"));
				},
				error: function(meh) {
 					response.error("Failed to run fbSignup task: " + JSON.stringify(meh, null, 4));
				}
			});
		else
			response.error("FB user has already been signed up!");
	});
});


/**
 * Attempts to send a password reset email.  Takes one param, the email to send the password reset.
 * Takes one param, email, in the following format: '{"email":"fastily@yahoo.com"}'
 */
 Parse.Cloud.define("resetPasswordRequest", function(request, response) {
 	Parse.User.requestPasswordReset(request.params.email, {
 		success: function(meh){
 			console.log("Sent password reset to " + request.params.email);
 			response.success();
 		},
 		error: function(err){
 			console.log("Error sending password reset to " + request.params.email);
 			response.error();
 		}
 	});
 });


/**
 * Identifies locations near a GeoPoint in a specific category. Restricted by radius (miles). 
 * Takes params: category, lat, long, radius.  Example:
 * {"category":"restroom", "lat":30, "lon:"30, "radius":40}
 */
 Parse.Cloud.define("locationsNearMe", function(request, response) {
 	new Parse.Query("Locations").withinMiles("location", 
 		new Parse.GeoPoint(request.params.lat, request.params.lon), request.params.radius).equalTo("category", request.params.category).find({
 			success: function(result) {
 				response.success(result);
 			},
 			error: function(meh){
 				console.log("Error in locationsNearMe: " + JSON.stringify(meh, null, 4));
 				response.error(meh);
 			}
 		});
 	});



/**
 * Grabs first row of a table where a given column is equal to a specific value.
 * Takes 3 params:
 * 		table - String - the table to query
 *		col - String - the column to search
 *		value - Object - the object to look for.
 */
function entryWhere(table, col, value)
{
	return new Parse.Query(table).equalTo(col, value).first().then(function(obj) {
		return obj;
	});
}


/**
 * Gets a user's Score entry.
 * Takes one param: user
 * Example: {"user":"Admin"}
 */
 Parse.Cloud.define("getUserScore", function(request, response) {
 	entryWhere("_User", "username", request.params.user).then(function(obj){
 		new Parse.Query("Score").equalTo("userID", obj).first().then(function(entry){
 			response.success(entry);
 		}, function(err){
 			response.error(err);
 		});
 	});
 });

/**
 *  Creates a pointer for the specified table and objectid
 *  Takes 2 params:
 * 		table - String - The table object
 *		objid - String - the objectId of the object to get.
 */
function makePointer(table, objid)
{
	return {__type: "Pointer", className: table, objectId: objid};
}


/**
 * Gets LocationRanks for the specified Locations object.
 * Takes one param: objid
 * Example: {"objid":"d70IYXni4G"}
 */
 Parse.Cloud.define("getLocationRanks", function(request, response){
 	new Parse.Query("LocationRank").equalTo("target", makePointer("Locations", request.params.objid)).find({
 		success:function(asdf) {
 			response.success(asdf);
 		},
 		error:function(err) {
 			response.error(err);
 		}
 	});
 });


/**
 * Get the number of event votes for a given event.
 * Takes one param:
 * 		obj - The unique objectId of the Event object we're trying to get votes for.
 * Example: {"obj":"CWwv1FzgPh"}
 */
Parse.Cloud.define("countEventVotes", function(request, response) {
	new Parse.Query("EventVotes").equalTo("target", makePointer("Events", request.params.obj)).limit(1000).count({
		success: function(asdf) {
			response.success(asdf);
		},
		error: function(err){
			response.error(err);
		}
	});
});


/**
 * Gets Events in descending (most recent first).  
 * Takes 2 OPTIONAL params: 
 * 		limit - limit the maximum number of items returned
 *		skip - Skip this many items before returning items.  Useful for pagination.
 * Example: {"limit":3, "skip":1}
 */
Parse.Cloud.define("getEvents", function(request, response){
	var q = new Parse.Query("Events").descending("start");
	if(request.params.limit)
		q.limit(request.params.limit);
	if(request.params.skip)
		q.skip(request.params.skip);

	q.find({
		success:function(obj) {
			response.success(obj);
		},
		error: function(err) {
			response.error(err)
		}
	});
});

/**
 * Get event comments for an event.
 * Takes 3 params: 
 * 		limit (OPTIONAL) - limit the maximum number of items returned
 *		skip (OPTIONAL) - Skip this many items before returning items.  Useful for pagination.
 * Example: {"limit":3, "skip":1, "obj":"CWwv1FzgPh"}
 */
Parse.Cloud.define("getEventComments", function(request, response){
	var q = new Parse.Query("EventCmt").equalTo("target", makePointer("Events", request.params.obj));
	if(request.params.limit)
		q.limit(request.params.limit);
	if(request.params.skip)
		q.skip(request.params.skip);

	q.find({
		success:function(obj) {
			response.success(obj);
		},
		error: function(err) {
			response.error(err)
		}
	});
});
