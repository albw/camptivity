Sample cURL code to test Cloud Modules
------

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

## Clound Functions
##### emailRegistered

Queries the email 'fastily@yahoo.com' against the Users table.  Returns true if this email exists in database.

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"email":"fastily@yahoo.com"}' \
https://api.parse.com/1/functions/emailRegistered
```

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


## OTHER
##### Create a new test user in the users table.

```bash
curl -X POST \
-H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
-H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
-H "Content-Type: application/json" \
-d '{"username":"TESTUSER1","password":"password","email":"thisisalecwu@gmail.com"}' \
https://api.parse.com/1/classes/_User
```