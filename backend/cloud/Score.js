/**
 * A class that contains methods for calculating Scores.
 * @class Score
 */
 var Utils = require("cloud/Utils.js");

 /* //////////////////////////////////////////////////////////////////////////////// */
 /* /////////////////////////// CLOUD FUNCTIONS //////////////////////////////////// */
 /* //////////////////////////////////////////////////////////////////////////////// */

/**
 * Gets a user's Score entry. Example: {"user":"Admin"}
 * @method getUserScore
 * @param {String} user The unique username of the user to get Score entries for.
 */
 exports.getUserScore = function(request, response) {
 	Utils.entryWhere("_User", "username", request.params.user).then(function(obj){
 		new Parse.Query("Score").equalTo("userID", obj).first(Utils.simpleSucErr(response));
 	});
 };
