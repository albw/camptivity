/**
 * A class that contains utility functions.  For internal use only.
 */

/**
 *  Creates a pointer for the specified table and objectid
 *  Takes 2 params:
 * 		table - String - The table object
 *		objid - String - the objectId of the object to get.
 * 	Returns a pointer.
 */
 exports.makePointer = function (table, objid) {
 	return {__type: "Pointer", className: table, objectId: objid};
 };

/**
 * Creates a JSON object with simple success and error methods.
 * Takes 1 param:
 * 		response - Object - The response object.
 * 	Returns a JSON object with success and error params.
 */
 exports.simpleSucErr = function(response) {
 	return {
 		success: function(obj) {
 			response.success(obj);
 		},
 		error: function(err){
 			console.log("Error: " + JSON.stringify(err, null, 4));
 			response.error(err);
 		}
 	};
 };

/**
 * Adds skip and and limit restrictions to a query if they exist.
 * Takes 2 params:
 * 		q - The query to apply changes to
 * 		skip - Optional para - The amount to skip by
 * 		limit - Optional param - the amount to limit by
 * Returns the query, q.
 */
 exports.querySkipAndLimit = function(q, skip, limit) {
 	if(skip)
 		q.skip(skip);
 	if(limit)
 		q.limit(limit);
 	return q;
 };

 /**
 * Grabs first row of a table where a given column is equal to a specific value.
 * Takes 3 params:
 * 		table - String - the table to query
 *		col - String - the column to search
 *		value - Object - the object to look for.
 *	Returns the row, if found.
 */
exports.entryWhere = function (table, col, value) {
	return new Parse.Query(table).equalTo(col, value).first().then(function(obj) {
		return obj;
	});
};


/**
 * Makes a date object using a String in the ISO 8601 format.  Dates *must* be in UTC timezone.
 * Takes one param:
 *		d - String - A string representation of the date in ISO 8601, UTC (e.g. "2011-08-21T18:02:52.249Z")
 * Returns a Parse-legal date representation of d.
 */
exports.makeDate = function(d) {
	return {"__type": "Date", "iso": d};
};
