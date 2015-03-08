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
-d '{"category":["restaurant", "bar"], "lat":32.88293263160078, "lon":-117.2109485336882, "radius":40}' \
https://api.parse.com/1/functions/locationsNearMe
```

##### newUserSignup

Attempts to register a new user.  Emulates use case where user wants to make an account without linking fb.

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"user":"TESTUSER2", "pass":"pw", "email":"fastily@yahoo.com", "name":"ALEC"}' \
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

##### getUserScore

Get a user's score using their username

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"user":"Admin"}' \
https://api.parse.com/1/functions/getUserScore
```


##### getLocationRanks

Get LocationRanks for a Locations object.

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"objid":"d70IYXni4G"}' \
https://api.parse.com/1/functions/getLocationRanks
```


##### getEvents

Get the (up to 1000 at once) per query most recent events.

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"limit":3, "skip":1}' \
https://api.parse.com/1/functions/getEvents
```


##### countEventVotes

Count up the number of event votes for a given event

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"obj":"CWwv1FzgPh"}' \
https://api.parse.com/1/functions/countEventVotes
```

##### getEventComments

Get the comments for an event

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"obj":"CWwv1FzgPh", "limit":1, "skip":1}' \
https://api.parse.com/1/functions/getEventComments
```

##### postEventCmt

Create a new EventCmt

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"comment":"supdawgs", "user":"Admin", "objectId": "CWwv1FzgPh"}' \
https://api.parse.com/1/functions/postEventCmt
```

##### postEvent

Create a new Event

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"name":"Ratchet Party 87", "user":"Admin", "desc": "lets get down n dirty", "lat":32, "lon":-117, "start":"2015-03-21T18:02:52.249Z", "expires":"2015-03-22T18:02:52.249Z"}' \
https://api.parse.com/1/functions/postEvent
```

##### postEventVote

Create a new EventVote

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"user":"Admin", "objectId": "CWwv1FzgPh"}' \
https://api.parse.com/1/functions/postEventVote
```

##### postLocationRank

Create a new LocationRank

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"user":"Admin", "rating": 2, "review":"This place is derped", "target":"gM2X4HWgXe"}' \
https://api.parse.com/1/functions/postLocationRank
```


##### postLocation

Create a new LocationRank

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"user":"Admin", "name": "TESTLOCATION", "desc":"Some test location", "lat":32, "lon":-117, "cat":"bar"}' \
https://api.parse.com/1/functions/postLocation
```

##### lookupEventByCoord

Lookup an event by coordinate

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"lat":32.883192, "lon":-117.240933}' \
https://api.parse.com/1/functions/lookupEventByCoord
```

##### lookupLocationByCoord

Lookup an event by coordinate

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"lat":32.883192, "lon":-117.240934}' \
https://api.parse.com/1/functions/lookupLocationByCoord
```
