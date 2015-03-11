/**
 * A class that contains methods related to user accounts.
 */

var Utils = require("cloud/Utils.js");

 /* //////////////////////////////////////////////////////////////////////////////// */
 /* /////////////////////////// CLOUD FUNCTIONS //////////////////////////////////// */
 /* //////////////////////////////////////////////////////////////////////////////// */

/**
 * Attempts to send a password reset email.  
 * Takes one param:
 * 		email - the email to send the password reset.
 * Example: '{"email":"fastily@yahoo.com"}'
 */
exports.resetPasswordRequest = function(request, response) {
 	Parse.User.requestPasswordReset(request.params.email, Utils.simpleSucErr(response));
 };

/**
 * Attempts to register a new user via Facebook.  The user logs in via the app, which will then save the results of a successful login to Parse.
 * Takes 3 params:
 *		fbID - User's Facebook Id.
 *		email - User's Email
 *		name - User's name
 * Example: {"fbID":"392874928", "email":"fastily@yahoo.com", "name":"Fastily"}
 */
 exports.fbSignup = function(request, response) {
	new Parse.Query("_User").equalTo("fbID", request.params.fbID).first().then(function(result){
		if(!result)
			Parse.User.signUp(request.params.email, "" + Math.random(), {email: request.params.email, name: request.params.name, fbID: request.params.fbID}, {
				success: function(ux) {
					response.success("Registered a new user via FB: " + ux.get("name") + " @ " + ux.get("fbID"));
				},
				error: function(meh) {
 					response.error("Failed to run fbSignup task: " + JSON.stringify(meh, null, 4));
				}
			});
		else
			response.error("FB user has already been signed up!");
	});
};

/**
 * Attempts to register a new user.  To be used when user does not wish to link his/her facebook profile. 
 * Takes 4 parameters:
 *		user - A username to register with.  This MUST be unique.
 *		pass - A password the user creates.
 *		email - The user's email.  This MUST be unique.
 *		name - The user's name.
 * Example: {"user":"Foo", "pass":"pw", "email":"thisisalecwu@gmail.com", "name":"ALEC"}
 */
exports.newUserSignup = function(request, response) {
 	Parse.Query.or(new Parse.Query("_User").equalTo("username", request.params.user), 
 		new Parse.Query("_User").equalTo("email", request.params.email)).first().then(function(result) {
 			if(!result) 
 				Parse.User.signUp(request.params.user, request.params.pass, {email: request.params.email, name: request.params.name}, {
 					success: function(ux) {
 						response.success("Signed up a new user: " + ux.get("username"));
 					},
 					error: function(meh) {
 						response.error("Failed to run newUserSignup task: " + JSON.stringify(meh, null, 4));
 					}
 				});
 			else
 				response.error("Username/Email has already been taken!")
 		});
 	};


/**
 * Determine if an email is registered
 * Takes one param:
 * 		email - the email to check
 * Example: '{"email":"fastily@yahoo.com"}'
 */
exports.emailIsRegistered = function(request, response) {
	new Parse.Query("_User").equalTo("email", request.params.email).first().then(function(meh){
		response.success(!meh ? false : true);
	}, function(e){
		response.error(e);
	});
};
