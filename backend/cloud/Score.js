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
