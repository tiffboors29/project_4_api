class BeersController < ApplicationController

  def index
    render json: Beer.all
  end

  def show
    render json: Beer.find(params[:id])
  end

end
