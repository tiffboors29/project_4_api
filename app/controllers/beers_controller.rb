class BeersController < ApplicationController

  def index
    # index the top 10 voted beers for the all states
    render json: Beer.all
  end

  def show
    # show the top 10 voted beers for the chosen state
    render json: Beer.find()
  end

  def create
    # when beer receives first vote, add it to beer table
    voted_beer = Beer.new(beer_params)
    if voted_beer.save
      render json: voted_beer
    else
      render json: voted_beer.errors, status: :unprocessable_entity
    end
  end

  def update
    # update votes if beer in table receives another vote
    voted_beer = Beer.find(params[:id])
    if voted_beer.update!(vote_params)
      render json: voted_beer
    else
      render json: voted_beer.errors, status: :unprocessable_entity
    end
  end

private
  def beer_params
    params.require(:voted_beer).permit(:title, :brewery, :type, :image, :votes)
  end

  def vote_params
    params.require(params.require(:voted_beer).permit(:votes))
  end

end
