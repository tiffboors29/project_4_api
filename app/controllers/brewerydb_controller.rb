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
    beer = Beer.new(beer_params)
    display_beer = brewery_db.beers.find(params[:beerId])

    if beer.save
      render json: display_beer
    else
      render json: beer.errors, status: :unprocessable_entity
    end
  end

  def test # need to get breweryId too
    display_beer = brewery_db.beers.find(params[:id])
    # new_beer = {}
    # new_beer["beer_id"] = display_beer.id
    # new_beer["brewery_id"] = display_beer.id
    # new_beer["votes"] = display_beer.id
    render json: display_beer
  end


private

  def set_brewery_db
    @brewery_db = BreweryDB::Client.new do |config|
      config.api_key = ENV['API_KEY']
    end
  end

  def beer_params
    params.require(:beer).permit(:brewery_id, :beer_id, :votes, :state_id)
  end
end
