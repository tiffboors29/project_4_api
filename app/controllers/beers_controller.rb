class BeersController < ApplicationController
  # incrementally add's votes & shows specific beer
  def increment_vote
    beer = Beer.find_by(beer_id: params[:beerId])
    beer.update({votes: (beer.votes + 1)})
    num_votes = beer.votes
    if beer.save
      render json: BreweryDb::ShowVotes.new(params[:beerId], num_votes).results
    else
      render json: beer.errors, status: :unprocessable_entity
    end
  end

  # show individual beer with brewerydb API info.
  def show_beer
    render json: BreweryDb::ShowBeer.new(params[:beerId]).results
  end

  # check if beer exists in beer table
  def check_ranked_beer
    if Beer.find_by(beer_id: params[:beerId])
      exists = true
    else
      exists = false
    end
    render json: exists
  end

  # get state's top 10 voted beers & show information
  def show_top_beers
    voted_beers = Beer.where(state_id: params[:stateId])
    ordered_ten = voted_beers.sort_by { |b| b['votes'] }.reverse.slice(0, 10)
    top_arr = []
    ordered_ten.each do |b|
      top_arr << BreweryDb::ShowVotes.new(b.beer_id, b.votes).results
    end
    render json: top_arr
  end
end
