#Project Notes

##BreweryDB API

BreweryDB API [Documentation](http://www.brewerydb.com/developers/docs)

###Notes for Using API
- API key required
- data sent back in JSON format
- for submitting new data, use application/x-www-form-urlencoded strings
- for GET requests, use query string (after the "?" in the request URL)
- for POST and PUT methods, these should be passed in the POST body
- standard access has a request limit of 400 requests per day on the read methods
- The request counter resets every night at midnight Eastern Standard Time
- Premium tier which has unlimited requests (costs $6/month or $60/year)
- main attributes in BreweryDB (beers, breweries, guilds, events and locations)
have status fields associated with them because it's a curated service
- status options: verified, new_unverified, update_pending, delete_pending, deleted
