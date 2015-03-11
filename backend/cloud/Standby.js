/**
 * Contains standby/aftersave routines
 */

 var Utils = require("cloud/Utils.js");

/* //////////////////////////////////////////////////////////////////////////////// */
/* /////////////////////////// INTERNAL STANDBY /////////////////////////////////// */
/* //////////////////////////////////////////////////////////////////////////////// */

/**
 * On creation of a new _User:
 * 
 * 1) Initialize a new Score entry for the user.
 */
exports.initUserScore = function(request) {
	if(request.object && !request.object.existed())
		new Parse.Object("Score").save({
			userID: request.object, 
			votesGiven: 0, 
			votesReceived: 0, 
			eventComments: 0, 
			locationsRanked: 0,
			eventsCreated: 0}).then(function(meh) {
				console.log("Initialized score row for " + request.object.get("username"));
			});
		};

/**
 * On creation of a new Location:
 * 
 * 1) Set the Location's numRankings and avgRank to 0.
 */
exports.initLocationAvgRank = function(request) {
	if(request.object && !request.object.existed())
		request.object.save({
			numRankings: 0,
			avgRank: 0
		}).then(function(meh){
 			console.log("Initialized averaging fields for new Location object: " + request.object.get("name"));
		});
};

/**
 * On creation of a new Event:
 * 
 * 1) Set the Event's upVotes to 0.
 * 2) Increment the creator's eventsCreated score by 1.
 */
exports.initEvent = function(request) {
	if(request.object && !request.object.existed())
		request.object.save({
			upVotes:0
		}).then(function(meh) {
			return incScoreField(request.object.get("userID"), "eventsCreated");
		}).then(function(meh) {
			console.log("Initialized upVotes value for new Events object: " + request.object.get("name"));
		});
};


/**
 * On creation of a new EventCmt:
 * 
 * 1) Increment the eventComments score for a user when they create an EventCmt.
 */
 exports.incEventCmtScore = function(request) {
 if(request.object && !request.object.existed())
 	incScoreField(request.object.get("userID"), "eventComments").then(function(asdf){
 		console.log("Incremented event comment score for: " + asdf.get("userID").id);
 	});
};


/**
 * On creation of a new EventVote:
 * 
 * 1) Increment the upVotes for the Event.
 * 2) Increment the votesGiven for the user who voted.
 * 3) Increment the votesReceieved for the user who created the Event.
 */
 exports.handleEventVote = function(request) {
 	if(request.object && !request.object.existed()) 
 		Utils.entryWhere("Events", "objectId", request.object.get("target").id).then(function(ev) {
 			ev.increment("upVotes", request.object.get("isUpVote") ? 1 : -1);
 			ev.save().then(function(meh) {
 				console.log("Incrementing votes recieved for " + ev.get("userID").id);
 				return incScoreField(ev.get("userID"), "votesReceived"); 
 			}).then(function(meh) {
 				console.log("Incrementing votes given for " + request.object.get("userID").id);
 				incScoreField(request.object.get("userID"), "votesGiven")

 			});
 		});
 };

/**
 * On creation of a new LocationRank:
 * 
 * 1) Re-computes the average for the Locations object referenced by this LocationRank. 
 * 2) Increment user's locationsRanked in Score table by one.
*/ 
exports.calcLocationRank = function(request) {
	if(request.object && !request.object.existed())
		Utils.entryWhere("Locations", "objectId", request.object.get("target").id).then(function(loc){
			loc.set("avgRank", (loc.get("numRankings") * loc.get("avgRank") + request.object.get("rating"))/(loc.get("numRankings") + 1));
			loc.increment("numRankings");
			return loc.save();

		}).then(function(meh){
			return incScoreField(meh.get("userID"), "locationsRanked");
		}).then(function(meh){
			console.log("Incremented locationsRanked score for " + meh.get("userID").id);
		});
};

/**
 * On creation of a new EventCmt:
 *
 * 1) Increment the eventComments score for a user when they create a comment.
 */
 exports.incEventCmtScore = function(request) {
 if(request.object && !request.object.existed())
 	incScoreField(request.object.get("userID"), "eventComments").then(function(asdf){
 		console.log("Incremented event comment score for: " + asdf.get("userID").id);
 	});
};

/* //////////////////////////////////////////////////////////////////////////////// */
/* /////////////////////////////////// JOBS /////////////////////////////////////// */
/* //////////////////////////////////////////////////////////////////////////////// */

/**
 * Deletes items that are unreachable/no longer have any references to them.
 */
exports.doGarbageCollect = function(request, response) {

	Utils.garbageCollect("Score", "userID", "_User").then(function(blah){
		response.success("Garbage Collect seems to have worked");
	},
	function(blah) {
		response.error("Uh oh");
	});
};


 /* //////////////////////////////////////////////////////////////////////////////// */
 /* /////////////////////////////// UTILITIES ////////////////////////////////////// */
 /* //////////////////////////////////////////////////////////////////////////////// */

/**
 * Increments a field in the Score table for a given user.
 * Takes two params:
 *		userId - pointer to the user's whos entry we'll be incrementing
 *		item -  a string naming the column to increment
 */
 function incScoreField(userId, item) {
 	return Utils.entryWhere("Score", "userID", userId).then(function(obj) {
 		obj.increment(item);
 		return obj.save();
 	});
 };
