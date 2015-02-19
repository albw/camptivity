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
 						response.error("Failed to run newUserSignup job: " + JSON.stringify(meh, null, 4));
 					}
 				});
 			else
 				response.error("Username/Email has already been taken!")
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