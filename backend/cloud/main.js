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
		sc.save({userID: request.object, likesGiven: 0, likesReceived: 0, eventComments: 0, locationReviews: 0}).then(function(meh) {
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
 * Performs following functions: 
 * 1) Re-computes the average for the Locations object referenced by this LocationRank. 
 * 2) Increment user's locationReviews in Score table by one.
 */ 
Parse.Cloud.afterSave("LocationRank", function(request) {
	if(request.object && !request.object.existed())
		new Parse.Query("Locations").get(request.object.get("target").id, {
			success: function(meh) {
				meh.set("avgRank", (meh.get("numRankings") * meh.get("avgRank") + request.object.get("rating"))/(meh.get("numRankings") + 1));
				meh.increment("numRankings");
				meh.save().then(function(blah) {
					console.log("Updated average of " + meh.get("name"));

					new Parse.Query("Score").equalTo("userID", meh.get("userID")).first().then(function(obj) {
							obj.increment("locationReviews");
							obj.save().then(function(asdf) {
								console.log("Incremented location review score for " + asdf.get("userID").id);
							});
					});
				});
			},
			error: function(ex) {
				console.log("OH NO: " + JSON.stringify(ex, null, 4 ));
			}
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
 		success: function(results)
 		{
 			Parse.Object.destroyAll(results).then(function(meh)
 			{
 				status.success("Job completed: " + results.length + " old event(s) pruned");
 			});
 		},
 		error: function(error)
 		{
 			status.error("Failed to nuke old events: " + error.message);	
 		}
 	});
 });


 /* //////////////////////////////////////////////////////////////////////////////// */
 /* /////////////////////////// CLOUD FUNCTIONS //////////////////////////////////// */
 /* //////////////////////////////////////////////////////////////////////////////// */


/**
 * Test function.  Returns a String
 */
 Parse.Cloud.define("hello", function(request, response) {
 	response.success("Hello, world!");
 });
