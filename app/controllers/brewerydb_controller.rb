class BrewerydbController < ApplicationController
  before_action :set_brewery_db

  attr_reader :brewery_db

  # show all breweries by location: state
  def state_breweries
    state_breweries = brewery_db.locations.all(region: params[:state])

    state_hash = {}

    state_breweries.each do |b|
      content = {}
      content['name'] = b.brewery.name
      content['id'] = b.breweryId
      content['website'] = b.brewery.website
      state_hash[b.breweryId] = content
    end

    render json: state_hash
  end

  # show all breweries by location: city
  def city_breweries
    city_breweries = brewery_db.locations.all(locality: params[:city])

    city_hash = {}

    city_breweries.each do |b|
      content = {}
      content['name'] = b.brewery.name
      content['id'] = b.breweryId
      content['website'] = b.brewery.website
      city_hash[b.breweryId] = content
    end

    render json: city_hash
  end

  # show all beers by location: state
  def state_beers
    state_breweries = brewery_db.locations.all(region: params[:state])
    state_arr = []
    beer_hash = {}

    # adds each brewery id to state_arr
    state_breweries.each do |b|
      state_arr << b.breweryId
    end

    # adds info for each beer to beer_hash with id as key
    state_arr.each do |b|
      beers = brewery_db.brewery(b).beers
      beers.each do |i|
        beer_hash[i.id] = {}
        content = {}
        content['name'] = i.name_display
        content['id'] = i.id
        content['breweryId'] = b
        content['abv'] = i.abv
        content['ibu'] = i.ibu
        content['isOrganic'] = i.isOrganic
        content['description'] = i.description
        beer_hash[i.id] = content
      end
    end

    render json: beer_hash
  end

  # show all beers by location: city
  def city_beers
    city_breweries = brewery_db.locations.all(locality: params[:city])
    city_arr = []
    beer_hash = {}

    # adds each brewery id to city_arr
    city_breweries.each do |b|
      city_arr << b.breweryId
    end

    # adds info for each beer to beer_hash with id as key
    city_arr.each do |b|
      beers = brewery_db.brewery(b).beers
      beers.each do |i|
        beer_hash[i.id] = {}
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

    render json: beer_hash
  end

  def create_voted_beer
    response = HTTParty.get('http://api.brewerydb.com/v2/beer/' + params[:beerId] + '?withBreweries=Y&key=' + ENV['API_KEY'] + '&format=json')

    # turns response data into hash
    data = response.parsed_response["data"]

    # need to find state_id from states table using state:
    # data['breweries'].first['locations'].first['region']
    state_id = State.find_by(name: data['breweries'].first['locations'].first['region']).id

    beer = Beer.new({
      title: data['nameDisplay'],
      beer_id: data['id'],
      brewery_id: data['breweries'].first['id'],
      state_id: state_id, #FIX ME (SEE ABOVE)
      votes: 1
    })

    display_beer = {}
    content = {}

    content['votes'] = 1
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
    display_beer['beer_id'] = content

    if beer.save
      render json: display_beer
    else
      render json: beer.errors, status: :unprocessable_entity
    end
  end

private

  def set_brewery_db
    @brewery_db = BreweryDB::Client.new do |config|
      config.api_key = ENV['API_KEY']
    end
  end

end
