Sample CURL code to test Cloud Modules
------

##### doAvg

Computes Average of 'rating' column in LocationRank

```bash
curl -X POST \
  -H "X-Parse-Application-Id: Y1fvAgliRdvCT1yXZBDNJtPm9QwMArNevFuWcqZm" \
  -H "X-Parse-REST-API-Key: 8DzbViZ3uzuZVp9bZ9rztDQEKG0Tx9fP1HLPsx5U" \
  -H "Content-Type: application/json" \
  -d '{"table":"LocationRank"}' \
  https://api.parse.com/1/functions/doAvg
  ```