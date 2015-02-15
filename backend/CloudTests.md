Sample cURL code to test Cloud Modules
------

##### afterSave (LocationRank)

Adds a test LocationRank object which will trigger following afterSave events: 
* Re-compute rankAvg and save result in the Locations table
* Increment user's locationReviews by one.

```bash
  curl -X POST \
  -H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
  -H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
  -H "Content-Type: application/json" \
  -d '{"rating":7,"review":"hehe3", "target":{"__type": "Pointer", "className": "Locations", "objectId": "d70IYXni4G"}, "userID":{"__type": "Pointer", "className": "_User", "objectId": "DQioyBlFOJ"}}' \
  https://api.parse.com/1/classes/LocationRank
 ```