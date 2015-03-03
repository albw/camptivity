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