/**
 * A class that contains methods for static Locations.
 */

var Utils = require("cloud/Utils.js");

 /* //////////////////////////////////////////////////////////////////////////////// */
 /* /////////////////////////// CLOUD FUNCTIONS //////////////////////////////////// */
 /* //////////////////////////////////////////////////////////////////////////////// */

/**
 * Gets LocationRanks for the specified Locations object.
 * Takes one param:
 *		objid - The unique objectId of the Location we're trying to get locationRanks for.
 * Example: {"objid":"d70IYXni4G"}
 */
 exports.getLocationRanks = function(request, response) {
 	new Parse.Query("LocationRank").equalTo("target", Utils.makePointer("Locations", request.params.objid)).find(Utils.simpleSucErr(response));
 };

/**
 * Identifies locations near a GeoPoint in a specific category. Restricted by radius (miles). 
 * Takes 4 params: 
 *		category - The String category/categories to select.  This is a String array.
 *		lat - The latitude of the GeoPoint to select.
 *		long - The longditude of the GeoPoint to select.
 * 		radius - The radius to search from the specified GeoPoint, in Miles.
 * Example: {"category":["restroom", "bar"], "lat":30, "lon:"30, "radius":40}
 */
 exports.locationsNearMe = function(request, response) {
 	new Parse.Query("Locations").withinMiles("location", 
 		new Parse.GeoPoint(request.params.lat, request.params.lon), request.params.radius).containedIn("category", 
 		request.params.category).find(Utils.simpleSucErr(response));
 	};


/**
 * Lookup Location by coordinate.
 * Takes 2 params:
 *		lat - Number - The latitude of the coordinate.
 *		lon - Number - The longitude of the coordinate.
 * Example: {"lat":32.883192, "lon":-117.240934}
 */
 exports.lookupLocationByCoord = function(request, response) {
 	Utils.lookupByLocation("Locations", request.params.lat, request.params.lon, response);
 };


/**
 * Post a new LocationRank.
 * Takes 4 params:
 *		user - String - the creator's username
 *		rating - Number - The user's rating of the location, out of 5.
 *		review - String - The The user's review of the location.
 *		target - String - The unique objectId of the Location object this LocationRank is referencing.
 *	Example: {"user":"Admin", "rating": 4, "review":"This place is rad", "target":"gM2X4HWgXe"}
 */
exports.postLocationRank = function(request, response) {
	Utils.entryWhere("_User", "username", request.params.user).then(function(obj) {
		new Parse.Object("LocationRank").save({
			userID: obj,
			rating: request.params.rating,
			review: request.params.review,
			target: Utils.makePointer("Locations", request.params.target)
		}, Utils.simpleSucErr(response));
	});
};

/**
 * Post a new Location.
 * Takes 6 params:
 *		user - String - the creator's username
 *		name - String - The name of the location.
 *		desc - String - A description of the location
 * 		lat - Number - The event's latitude.
 *		lon - Number - The event's longitude.
 *		cat - String - This item's category.
 *	Example: {"user":"Admin", "name": "TESTLOCATION", "desc":"Some test location", "lat":32, "lon":-117, "cat":"bar"}
 */
exports.postLocation = function(request, response) {
	Utils.entryWhere("_User", "username", request.params.user).then(function(obj) {
		new Parse.Object("Locations").save({
			userID: obj,
			name: request.params.name,
			description: request.params.desc,
			location: new Parse.GeoPoint(request.params.lat, request.params.lon),
			category: request.params.cat
		}, Utils.simpleSucErr(response));
	});
};