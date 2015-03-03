/**
 * A class that contains methods for calculating Scores.
 */
 var Utils = require("cloud/Utils.js");

 /* //////////////////////////////////////////////////////////////////////////////// */
 /* /////////////////////////// CLOUD FUNCTIONS //////////////////////////////////// */
 /* //////////////////////////////////////////////////////////////////////////////// */

/**
 * Gets a user's Score entry.
 * Takes one param:
 * 		user - The unique username of the user to get Score entries for.
 * Example: {"user":"Admin"}
 */
 exports.getUserScore = function(request, response) {
 	Utils.entryWhere("_User", "username", request.params.user).then(function(obj){
 		new Parse.Query("Score").equalTo("userID", obj).first(Utils.simpleSucErr(response));
 	});
 };


 /* //////////////////////////////////////////////////////////////////////////////// */
 /* /////////////////////////// INTERNAL STANDBY /////////////////////////////////// */
 /* //////////////////////////////////////////////////////////////////////////////// */

/**
 * Increment the event comment score for a user when they create a comment.
 */
 exports.incEventCmtScore = function(request) {
 if(request.object && !request.object.existed())
 	incScoreField(request.object.get("userID"), "eventComments").then(function(asdf){
 		console.log("Incremented event comment score for: " + asdf.get("userID").id);
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
 	return new Parse.Query("Score").equalTo("userID", userId).first().then(function(obj) {
 		obj.increment(item);
 		return obj.save();
 	});
 }