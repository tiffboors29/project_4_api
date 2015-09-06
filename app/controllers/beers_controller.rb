class BeersController < ApplicationController

  before_action :authorize, only: [:index, :show, :create, :update]

  def index
    render json: Beer.all
  end

  def show
    render json: Beer.find(params[:id])
  end

end
