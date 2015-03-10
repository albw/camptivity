var Utils = require("cloud/Utils.js");

 /* //////////////////////////////////////////////////////////////////////////////// */
 /* /////////////////////////// CLOUD FUNCTIONS //////////////////////////////////// */
 /* //////////////////////////////////////////////////////////////////////////////// */

/**
 * Get event comments for an event.  EventCmts are returned from Parse in sequential, ascending order.
 * Takes 3 params: 
 * 		limit - Number (OPTIONAL) - how many items to return (max=1000)
 *		skip - Number (OPTIONAL) - Skip this many items before returning more items.  Useful for pagination.
 *		obj - String - The objectId of the Event to get EventCmts for.
 * Example: {"limit":3, "skip":1, "obj":"CWwv1FzgPh"}
 */
exports.getEventComments = function(request, response) {
	Utils.querySkipAndLimit(new Parse.Query("EventCmt").equalTo("target", Utils.makePointer("Events", request.params.obj)), 
		request.params.skip, request.params.limit).ascending("createdAt").find(Utils.simpleSucErr(response));
};


/**
 * Gets Events in descending (most recent first).  
 * Takes 2 OPTIONAL params: 
 * 		limit - limit the maximum number of items returned
 *		skip - Skip this many items before returning items.  Useful for pagination.
 * Example: {"limit":3, "skip":1}
 */
exports.getEvents = function(request, response){
	Utils.querySkipAndLimit(new Parse.Query("Events").descending("start"), request.params.skip, 
		request.params.limit).include("userID").find(Utils.simpleSucErr(response));
};


/**
 * Get the number of event votes for a given event.
 * Takes one param:
 * 		obj - The unique objectId of the Event object we're trying to get votes for.
 * Example: {"obj":"CWwv1FzgPh"}
 */
exports.countEventVotes = function(request, response) {
	new Parse.Query("EventVotes").equalTo("target", Utils.makePointer("Events", request.params.obj)).limit(1000).count(Utils.simpleSucErr(response));
};


/**
 * Posts a new EventCmt.
 * Takes 3 params:
 *		comment - The comment
 *		user - The user's username
 *		target - The objectId of the event to post for.
 *	Example: {"comment":"yolo", "user":"Admin", "objectId": "CWwv1FzgPh"}
 */
 exports.postEventCmt = function(request, response) {
 	Utils.entryWhere("_User", "username", request.params.user).then(function(obj) {
 		new Parse.Object("EventCmt").save({
 			comment : request.params.comment,
 			userID: obj,
 			target: Utils.makePointer("Events", request.params.objectId)
 		}, Utils.simpleSucErr(response));
 	});
 };

/**
 * Posts a new Event object.
 * Takes 7 params:
 * 		name - String - the name of the event.
 *		desc - Stirng - The event description.
 * 		lat - Number - The event's latitude.
 *		lon - Number - The event's longitude.
 *		user - String - The creator's username.
 * 		start - String - The start date. A date/time in ISO 8601, UTC (e.g. "2011-08-21T18:02:52.249Z")
 *		expires - String - The end date. A date/time in ISO 8601, UTC (e.g. "2011-08-21T18:02:52.249Z")
 * Example: {"name":"Ratchet Party", "user":"Admin", "desc": "lets get down n dirty", "lat":32, "lon":-117, "start":"2015-03-21T18:02:52.249Z", "expires":"2015-03-22T18:02:52.249Z"}
 */
exports.postEvent = function(request, response) {
 	Utils.entryWhere("_User", "username", request.params.user).then(function(obj) {
 		new Parse.Object("Events").save({
 			name : request.params.name,
 			description: request.params.desc,
 			location: new Parse.GeoPoint(request.params.lat, request.params.lon),
 			userID: obj,
 			start: Utils.makeDate(request.params.start),
 			expires: Utils.makeDate(request.params.expires)
 		}, Utils.simpleSucErr(response));
 	});
 };

/**
 * Posts a new EventVote.
 * Takes 3 params:
 *		user - String - The user's username
 *		target - String - The objectId of the Event to post for.
 *		isUpVote - Boolean - Indicates whether this EventVote is an upVote.
 *	Example: {"user":"Admin", "objectId": "CWwv1FzgPh"}
 */
exports.postEventVote = function(request, response) {
 	Utils.entryWhere("_User", "username", request.params.user).then(function(obj) {
 		new Parse.Object("EventVotes").save({
 			userID: obj,
 			isUpVote: request.params.isUpVote,
 			target: Utils.makePointer("Events", request.params.objectId)
 		}, Utils.simpleSucErr(response));
 	});
 };


/* //////////////////////////////////////////////////////////////////////////////// */
/* /////////////////////////////////// JOBS /////////////////////////////////////// */
/* //////////////////////////////////////////////////////////////////////////////// */

/**
 * Goes through the Events table and drops rows with expired events.
 */
exports.nukeDeadEvents = function(request, response) {
 	Parse.Cloud.useMasterKey();
 	new Parse.Query("Events").lessThan("expires", new Date()).find({
 		success: function(results) {
 			Parse.Object.destroyAll(results).then(function(meh) {
 				response.success("Job completed: " + results.length + " old event(s) pruned");
 			});
 		},
 		error: function(error) {
 			response.error("Failed to nuke old events: " + error.message);	
 		}
 	});
 };