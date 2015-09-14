class BreweryDb
  class CreateVotedbeer

    def initialize(beerId)
      @beer_id = beerId
      @response = request
      @parsed_data = parse
      @state_id = get_state
    end

    # sends request to breweryDB API
    def request
      HTTParty.get('http://api.brewerydb.com/v2/beer/' + @beer_id + '?withBreweries=Y&key=' + ENV['API_KEY'] + '&format=json')
    end

    # parse API response data into hash
    def parse
      @response.parsed_response['data']
    end

    # get state_id in order to add create new beer
    def get_state
      State.find_by(name: @parsed_data['breweries'].first['locations'].first['region']).id
    end

    # insert new beer into beer table w/ vote and state_id
    def create
      beer = Beer.new({
        title: @parsed_data['nameDisplay'],
        beer_id: @parsed_data['id'],
        brewery_id: @parsed_data['breweries'].first['id'],
        state_id: @state_id,
        votes: 1
      })
      if beer.save
        display_beer
      else
        render json: beer.errors, status: :unprocessable_entity
      end
    end

    # build hash to desplay beer info with votes
    def display_beer
      display_beer = {}
      content = {}
      content['votes'] = 1
      content['beer_id'] = @parsed_data['id']
      content['name'] = @parsed_data['nameDisplay']
      content['abv'] = @parsed_data['abv']
      content['ibu'] = @parsed_data['ibu']
      content['isOrganic'] = @parsed_data['isOrganic']
      content['description'] = @parsed_data['style']['description']
      content['brewery_id'] = @parsed_data['breweries'].first['id']
      content['brewery_name'] = @parsed_data['breweries'].first['name']
      content['brewery_website'] = @parsed_data['breweries'].first['website']
      content['state'] = @parsed_data['breweries'].first['locations'].first['region']
      display_beer['beer_id'] = content
      return display_beer
    end
  end
end
