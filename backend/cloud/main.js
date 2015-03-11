var Events = require("cloud/Events.js");
var Locations = require("cloud/Locations.js");
var Score = require("cloud/Score.js");
var Standby = require("cloud/Standby.js");
var Users = require("cloud/Users.js");

/* //////////////////////////////////////////////////////////////////////////////// */
/* /////////////////////////// INTERNAL STANDBY /////////////////////////////////// */
/* //////////////////////////////////////////////////////////////////////////////// */

/**
 * On creation of a new _User:
 * 
 * 1) Initialize a new Score entry for the user.
 */
Parse.Cloud.afterSave("_User", Standby.initUserScore);

/**
 * On creation of a new Location:
 * 
 * 1) Set the Location's numRankings and avgRank to 0.
 */
Parse.Cloud.afterSave("Locations", Standby.initLocationAvgRank);

/**
 * On creation of a new LocationRank:
 * 
 * 1) Re-computes the average for the Locations object referenced by this LocationRank. 
 * 2) Increment user's locationsRanked in Score table by one.
 */ 
Parse.Cloud.afterSave("LocationRank", Standby.calcLocationRank);

/**
 * On creation of a new EventVote:
 * 
 * 1) Increment the upVotes for the Event.
 * 2) Increment the votesGiven for the user who voted.
 * 3) Increment the votesReceieved for the user who created the Event.
 */

Parse.Cloud.afterSave("EventVotes", Standby.handleEventVote);

/**
 * On creation of a new EventCmt:
 *
 * 1) Increment the eventComments score for a user when they create a comment.
 */
Parse.Cloud.afterSave("EventCmt", Standby.incEventCmtScore);

/**
 * On creation of a new Event:
 * 
 * 1) Set the Event's upVotes to 0.
 */
Parse.Cloud.afterSave("Events", Standby.initEvent);

/* //////////////////////////////////////////////////////////////////////////////// */
/* /////////////////////////////////// JOBS /////////////////////////////////////// */
/* //////////////////////////////////////////////////////////////////////////////// */

/**
 * Goes through the Events table and drops rows with expired events.
 */
 Parse.Cloud.job("nukeDeadEvents", Events.nukeDeadEvents);

/**
 * Nerf unreferenced objects.  For internal use only.
 */
 Parse.Cloud.job("doGarbageCollect", Standby.doGarbageCollect);


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
 * Gets a user's Score entry. Example: {"user":"Admin"}
 * @method getUserScore
 * @param {String} user The unique username of the user to get Score entries for.
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
 * Get event comments for an event.  EventCmts are returned from Parse in sequential, ascending order.
 * Takes 3 params: 
 * 		limit - Number (OPTIONAL) - how many items to return (max=1000)
 *		skip - Number (OPTIONAL) - Skip this many items before returning more items.  Useful for pagination.
 *		obj - String - The objectId of the Event to get EventCmts for.
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
 Parse.Cloud.define("postEvent", Events.postEvent);

/**
 * Posts a new EventVote.
 * Takes 3 params:
 *		user - String - The user's username
 *		target - String - The objectId of the Event to post for.
 *		isUpVote - Boolean - Indicates whether this EventVote is an upVote.
 *	Example: {"user":"Admin", "objectId": "CWwv1FzgPh"}
 */
 Parse.Cloud.define("postEventVote", Events.postEventVote);

/**
 * Post a new LocationRank.
 * Takes 4 params:
 *		user - String - the creator's username
 *		rating - Number - The user's rating of the location, out of 5.
 *		review - String - The The user's review of the location.
 *		target - String - The unique objectId of the Location object this LocationRank is referencing.
 *	Example: {"user":"Admin", "rating": 4, "review":"This place is rad", "target":"gM2X4HWgXe"}
 */
 Parse.Cloud.define("postLocationRank", Locations.postLocationRank);
