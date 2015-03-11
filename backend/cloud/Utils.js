/**
 * A class that contains utility functions.  For internal use only.
 * @class Utils
 */

var _ = require("underscore");

/**
 *  Creates a pointer for the specified table and objectid
 *  @method makePointer
 *	@param {String} table The table object
 *  @param {String} objid The objectId of the object to get.
 *	@return {Object) A Parse pointer.
 */
 exports.makePointer = function (table, objid) {
 	return {__type: "Pointer", className: table, objectId: objid};
 };

/**
 * Creates a JSON object with simple success and error methods.
 * @method simpleSucErr
 * @param {Object} response The response object.
 * @return {Object} A JSON object with success and error params.
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
 * @method querySkipAndLimit
 * @param {Parse.Query} q The query to apply changes to
 * @param {Integer} [skip=0] The amount to skip by
 * @param {Integer} [limit=0] The amount to limit by
 * @return {Parse.Query} The query, q.
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
 * @method entryWhere
 * @param {String} table the table to query
 * @param {String} col the column to search
 * @param {Object} value the object to look for.
 * @return {Parse.Promise} The row, if found.
 */
exports.entryWhere = function (table, col, value) {
	return new Parse.Query(table).equalTo(col, value).first().then(function(obj) {
		return obj;
	});
};


/**
 * Makes a date object using a String in the ISO 8601 format.  Dates *must* be in UTC timezone.
 * @method makeDate
 * @param {String} d A string representation of the date in ISO 8601, UTC (e.g. "2011-08-21T18:02:52.249Z")
 * @return A Parse-legal date representation of d.
 */
exports.makeDate = function(d) {
	return {"__type": "Date", "iso": d};
};


/**
 * Garbage collect items in a table.  
 * @method garbageCollect
 * @param table The table to query
 * @param col The column to look for pointers in
 * @param targetTable The table that pointers in col are pointing to.
 * @return A resolved Parse Promise.
 */
exports.garbageCollect = function(table, col, targetTable) {
	return new Parse.Query(table).exists(col).find().then(function(results){
		var p = Parse.Promise.as();

		_.each(results, function(obj){
			p = p.then(function(foo){

			    return new Parse.Query(targetTable).equalTo("objectId", obj.get(col).id).first();
			}).then(function(meh) {
				
			    return !meh ? obj.destroy().then(function(meh){
			       	   console.log("Deleted item: [" + obj.id + " @ " + table + "]");
			       	   return Parse.Promise.as();
			       }) : Parse.Promise.as();
			    });
			});

		return p;
		});
	};