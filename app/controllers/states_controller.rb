class StatesController < ApplicationController

  before_action :authorize, only: [:index, :show]
  def index
    render json: State.all
  end

  def show
    render json: State.find(params[:id])
  end

end
