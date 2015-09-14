class BreweryDb
  class ShowBeer

    def initialize(beerId)
      @beer_id = beerId
      @response = request
      @parsed_data = parse
    end

    def request
      HTTParty.get('http://api.brewerydb.com/v2/beer/' + @beer_id + '?withBreweries=Y&key=' + ENV['API_KEY'] + '&format=json')
    end

    def parse
      @response.parsed_response['data']
    end

    def results
      data = @parsed_data
      hash = {}
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
      hash['beer_id'] = content
      return hash
    end
  end
end
