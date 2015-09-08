## could put in application controller with getter for all controller's to use. or.... do this

# class FooController
#   before_action :set_brewery_db

#   attr_reader :brewery_db

#   def show
#     brewery_db.locations......
#   end

# private
#   def set_brewery_db
#     @brewery_db = BreweryDB::Client.new do |config|
#       config.api_key = ENV['API_KEY']
#     end
#   end
# end

# -----------------------------------------------

brewery_db = BreweryDB::Client.new do |config|
  config.api_key = ENV['API_KEY']
end

# michigan = brewery_db.beers.all(abv: '5.5')
# beers = brewery_db.locations.all(locality: ARGV[0])
# p beers

#--Search for breweries in a state---------------
#--Creates Hash with k:breweryId & v:Name--------
state_breweries = brewery_db.locations.all(region: ARGV[0])

state_hash = {}

state_breweries.each do |b|
  state_hash[b.breweryId] = b.brewery.name
end


#--Search for breweries in a city---------------
#--Creates Hash with k:breweryId & v:Name--------
city_breweries = brewery_db.locations.all(locality: ARGV[0])

city_hash = {}

city_breweries.each do |b|
  city_hash[b.breweryId] = b.brewery.name
end

#--Search for all beers in a state---------------
#--Creates Hash with --------
state_breweries = brewery_db.locations.all(region: ARGV[0])

state_arr = []

# adds each brewery id to state_arr
state_breweries.each do |b|
  state_arr << b.breweryId
  # p b.brewery.name
end

beer_hash = {}

state_arr.each do |b|
  beers = brewery_db.brewery(b).beers
  beers.each do |i|
    beer_hash[i.id] = {}
    content = {}
    content['name'] = i.name_display
    content['id'] = i.id
    content['abv'] = i.abv
    content['ibu'] = i.ibu
    content['isOrganic'] = i.isOrganic
    content['description'] = i.description
    beer_hash[i.id] = content
  end
end

p beer_hash.first

#--------------------------------------------
