## Standby Routines
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



##### afterSave (EventVotes)

Adds a new EventVote row.  This will trigger the following events:
* Increment number of votesGiven for user who voted.
* Increment number of votesRecieved for user who recieved the vote.

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"target":{"__type": "Pointer", "className": "Events", "objectId": "CWwv1FzgPh"}, "userID":{"__type": "Pointer", "className": "_User", "objectId": "DQioyBlFOJ"}}' \
https://api.parse.com/1/classes/EventVotes
```



## Clound Functions

##### resetPasswordRequest

Sends a password reset email.

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"email":"thisisalecwu@gmail.com"}' \
https://api.parse.com/1/functions/resetPasswordRequest
```

##### locationsNearMe

Gets a list of locations of a specific category near a lat/long.

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"category":"restroom", "lat":32.88293263160078, "lon":-117.2109485336882, "radius":40}' \
https://api.parse.com/1/functions/locationsNearMe
```

##### newUserSignup

Attempts to register a new user.  Emulates use case where user wants to make an account without linking fb.

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"user":"Foo", "pass":"pw", "email":"thisisalecwu@gmail.com", "name":"ALEC"}' \
https://api.parse.com/1/functions/newUserSignup
```

##### fbSignup

Attempts to register a new user via the locally authenticated Facebook route. 

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"fbID":"392874928", "email":"fastily@yahoo.com", "name":"Fastily"}' \
https://api.parse.com/1/functions/fbSignup
```
