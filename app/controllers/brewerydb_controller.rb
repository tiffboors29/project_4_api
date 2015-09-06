class BrewerydbController < ApplicationController

  before_action :authorize, only: [:test]

  def test
    result = $brewery_db.beers.find('vYlBZQ')
    render json: result
  end

end
