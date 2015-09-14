class BreweryDb
  class ShowBeers
    attr_reader :brewery_db

    def initialize(location_type, location)
      @location = location
      @location_type = location_type
      @brewery_db = set_brewery_db
    end

    # build hash to desplay beer info
    def results
      if (@location_type == 'state')
        breweries = brewery_db.locations.all(region: @location)
      elsif (@location_type == 'city')
        breweries = brewery_db.locations.all(locality: @location)
      end
      brewery_arr = []
      beer_arr = []
      # adds each brewery id to state_arr
      breweries.each do |b|
        brewery_arr << b.breweryId
      end
      # adds info for each beer to beer_arr with id as key
      brewery_arr.each do |b|
        beers = brewery_db.brewery(b).beers
        brewery = brewery_db.breweries.find(b)
        beers.each do |i|
          content = {}
          content['name'] = i.name_display
          content['id'] = i.id
          content['breweryId'] = b
          content['brewery_name'] = brewery.name
          content['brewery_website'] = brewery.website
          content['abv'] = i.abv
          content['ibu'] = i.ibu
          content['isOrganic'] = i.isOrganic
          content['description'] = i.description
          beer_arr << content
        end
      end
      return beer_arr
    end

    private
    # configuration for brewery_db gem
    def set_brewery_db
      @brewery_db = BreweryDB::Client.new do |config|
        config.api_key = ENV['API_KEY']
      end
    end
  end
end
