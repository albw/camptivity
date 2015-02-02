
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});


Parse.Cloud.job("nukeDeadEvents", function(request, status)
{
	Parse.Cloud.useMasterKey();


	var query = new Parse.Query(Parse.Object.extend("Events"));
	query.lessThan("expires", new Date());
	query.find({
		success: function(results)
		{
			Parse.Object.destroyAll(results).then(function(meh)
			{
				status.success("Job completed: " + results.length + " old events pruned");
			});
		},
		error: function(error)
		{
			status.error("Failed to nuke old events: " + error.message);	
		}
	});
});



