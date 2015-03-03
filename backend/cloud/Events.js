var Utils = require("cloud/Utils.js");

 /* //////////////////////////////////////////////////////////////////////////////// */
 /* /////////////////////////// CLOUD FUNCTIONS //////////////////////////////////// */
 /* //////////////////////////////////////////////////////////////////////////////// */

/**
 * Get event comments for an event.
 * Takes 3 params: 
 * 		limit (OPTIONAL) - limit the maximum number of items returned
 *		skip (OPTIONAL) - Skip this many items before returning items.  Useful for pagination.
 * Example: {"limit":3, "skip":1, "obj":"CWwv1FzgPh"}
 */
exports.getEventComments = function(request, response) {
	Utils.querySkipAndLimit(new Parse.Query("EventCmt").equalTo("target", Utils.makePointer("Events", request.params.obj)), 
		request.params.skip, request.params.limit).find(Utils.simpleSucErr(response));
};


/**
 * Gets Events in descending (most recent first).  
 * Takes 2 OPTIONAL params: 
 * 		limit - limit the maximum number of items returned
 *		skip - Skip this many items before returning items.  Useful for pagination.
 * Example: {"limit":3, "skip":1}
 */
exports.getEvents = function(request, response){
	Utils.querySkipAndLimit(new Parse.Query("Events").descending("start"), request.params.skip, request.params.limit).find(Utils.simpleSucErr(response));
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