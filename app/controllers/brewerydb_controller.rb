class BrewerydbController < ApplicationController
  before_action :set_brewery_db

  attr_reader :brewery_db

  # show all breweries by location: state
  def state_breweries
    render json: BreweryDb::ShowBreweries.new('state', params[:state]).results
  end

  # show all breweries by location: postalCode
  def postal_breweries
    render json: BreweryDb::ShowBreweries.new('postal', params[:postal]).results
  end

  # show all beers by location: state
  def state_beers
    render json: BreweryDb::ShowBeers.new('state', params[:state]).results
  end

  # show all beers by location: postalCode
  def postal_beers
    render json: BreweryDb::ShowBeers.new('postal', params[:postal]).results
  end

  # insert new beer into beer table with 1 vote
  def create_voted_beer
    render json: BreweryDb::CreateVotedbeer.new(params[:beerId]).create
  end

private
  # configuration for brewery_db gem
  def set_brewery_db
    @brewery_db = BreweryDB::Client.new do |config|
      config.api_key = ENV['API_KEY']
    end
  end

end
