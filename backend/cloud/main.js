
/**
 * Internal job that goes through Events table and deletes all expired events.
 */
Parse.Cloud.job("nukeDeadEvents", function(request, status)
{
	Parse.Cloud.useMasterKey();
	new Parse.Query(Parse.Object.extend("Events")).lessThan("expires", new Date()).find({
		success: function(results)
		{
			Parse.Object.destroyAll(results).then(function(meh)
			{
				status.success("Job completed: " + results.length + " old event(s) pruned");
			});
		},
		error: function(error)
		{
			status.error("Failed to nuke old events: " + error.message);	
		}
	});
});

/**
 * Shitty compute average rankings function.  CAVEAT: Will give incorrect 
 * result if there are more than 1000 rankings. 
 *
 * Takes one parameter: a JSON object that contains a single element (table) keyed to 
 * either "EventRank" or "LocationRank" depending on which to calculate avg for:
 * (e.g. {"table":"LocationRank"})
 */
Parse.Cloud.define("doAvg", function(request, response)
{
	new Parse.Query(Parse.Object.extend(request.params.table)).exists("rating").find({
		success: function(result)
		{
			var x = 0;
			for(var i = 0; i < result.length; i++)
				x += result[i].get("rating");

			response.success(x / result.length);

		},
		error: function(error)
		{
			response.error("Failed to compute average! " + error.message);
		}
	});
});