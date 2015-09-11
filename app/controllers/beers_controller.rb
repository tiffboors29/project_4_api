class BeersController < ApplicationController

  ####[create] beer gets created on brewerydb_controller
  #### it is called create_voted_beer

  # incrementally add's votes to specific beer
  def increment_vote
    beer = Beer.find_by(beer_id: params[:beerId])
    new_votes = beer.votes + 1
    beer.update({
      votes: new_votes
      })

    num_votes = beer.votes
    if beer.save
      render json: show_beer_arg(params[:beerId], num_votes)
    else
      render json: beer.errors, status: :unprocessable_entity
    end
  end

  # show individual beer with APIdb info.
  # function searches by request params
  def show_beer
    response = HTTParty.get('http://api.brewerydb.com/v2/beer/' + params[:beerId] + '?withBreweries=Y&key=' + ENV['API_KEY'] + '&format=json')
    # turns response data into hash
    data = response.parsed_response['data']
    beer_hash = {}
    content = {}

    content['beer_id'] = data['id']
    content['name'] = data['nameDisplay']
    content['abv'] = data['abv']
    content['ibu'] = data['ibu']
    content['isOrganic'] = data['isOrganic']
    content['description'] = data['style']['description']
    content['brewery_id'] = data['breweries'].first['id']
    content['brewery_name'] = data['breweries'].first['name']
    content['brewery_website'] = data['breweries'].first['website']
    content['state'] = data['breweries'].first['locations'].first['region']

    beer_hash['beer_id'] = content

    render json: beer_hash
  end

  # show individual beer with APIdb info.
  # function searches by argument passed & returns hash
  def show_beer_arg(beerId, num_votes)
    response = HTTParty.get('http://api.brewerydb.com/v2/beer/' + beerId + '?withBreweries=Y&key=' + ENV['API_KEY'] + '&format=json')
    # turns response data into hash
    data = response.parsed_response['data']
    beer_hash = {}
    content = {}

    content['beer_id'] = data['id']
    content['name'] = data['nameDisplay']
    content['abv'] = data['abv']
    content['ibu'] = data['ibu']
    content['isOrganic'] = data['isOrganic']
    content['description'] = data['style']['description']
    content['brewery_id'] = data['breweries'].first['id']
    content['brewery_name'] = data['breweries'].first['name']
    content['brewery_website'] = data['breweries'].first['website']
    content['state'] = data['breweries'].first['locations'].first['region']
    content['votes'] = num_votes

    beer_hash['beer_id'] = content

    return beer_hash
  end

  # use params[:state_id] to get top 10 most highest voted beers
  # in the state with all show information
  def show_top_beers
    voted_beers = Beer.where(state_id: params[:stateId])

    ordered = voted_beers.sort_by { |b| b['votes'] }.reverse
    ordered_ten =  ordered.slice(0, 10)
    top_arr = []

    ordered_ten.each do |b|
      top_arr << show_beer_arg(b.beer_id, b.votes)
    end

    render json: top_arr
  end

end
