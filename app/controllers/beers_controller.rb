class BeersController < ApplicationController

  # before_action :authorize, only: [:index, :show, :create, :update]

  def index
    render json: Beer.all
  end

  def show
    render json: Beer.find(params[:id])
  end

  # def create  # create moved to brewerydb_controller
  #   beer = Beer.new(beer_params)
  #   if beer.save
  #     render json: beer
  #   else
  #     render json: beer.errors, status: :unprocessable_entity
  #   end
  # end

  def update
    beer = Beer.find(params[:id])
    if beer.update!(vote_params)
      render json: beer
    else
      render json: beer.errors, status: :unprocessable_entity
    end
  end

private

  def vote_params
    params.require(:beer).permit(:votes)
  end

end
