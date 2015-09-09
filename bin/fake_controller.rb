brewery_db = BreweryDB::Client.new do |config|
  config.api_key = ENV['API_KEY']
end

#--Search for breweries in a state---------------
#--Creates Hash with k:breweryId & v:Name--------
state_breweries = brewery_db.locations.all(region: ARGV[0])

state_hash = {}

state_breweries.each do |b|
  content = {}
  content['name'] = b.brewery.name
  content['id'] = b.breweryId
  content['website'] = b.brewery.website
  state_hash[b.breweryId] = content
end

#--Search for breweries in a city---------------
#--Creates Hash with k:breweryId & v:Name--------
city_breweries = brewery_db.locations.all(locality: ARGV[0])

city_hash = {}

city_breweries.each do |b|
  content = {}
  content['name'] = b.brewery.name
  content['id'] = b.breweryId
  content['website'] = b.brewery.website
  city_hash[b.breweryId] = content
end

#--Search for all beers in a state---------------
#--Creates Hash with --------
state_breweries = brewery_db.locations.all(region: ARGV[0])

state_arr = []

# adds each brewery id to state_arr
state_breweries.each do |b|
  state_arr << b.breweryId
end

beer_hash = {}

state_arr.each do |b|
  beers = brewery_db.brewery(b).beers
  beers.each do |i|
    content = {}
    content['name'] = i.name_display
    content['id'] = i.id
    content['abv'] = i.abv
    content['breweryId'] = b
    content['ibu'] = i.ibu
    content['isOrganic'] = i.isOrganic
    content['description'] = i.description
    beer_hash[i.id] = content
  end
end

#--------------------------------------------
# create voted beer

display_beer = HTTParty.get('http://api.brewerydb.com/v2/beer/' + ARGV[0] + '?withBreweries=Y&key=' + ENV['API_KEY'] + '&format=json')

data = display_beer.parsed_response["data"]
#### data is now a hash

beer_hash = {}
content = {}

content['beer_id'] = data['id']
content['name'] = data['nameDisplay']
content['abv'] = data['abv']
content['ibu'] = data['ibu']
content['isOrganic'] = data['isOrganic']
content['description'] = data['style']['description']
content['image'] = data['labels']['medium']
content['brewery_id'] = data['breweries'].first['id']
content['brewery_name'] = data['breweries'].first['name']
content['brewery_website'] = data['breweries'].first['website']
content['brewery_image'] = data['breweries'].first['images']['medium']
content['state'] = data['breweries'].first['locations'].first['region']
beer_hash['beer_id'] = content

p beer_hash
