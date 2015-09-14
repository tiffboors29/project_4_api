class BreweryDb
  class ShowBreweries
    attr_reader :brewery_db

    def initialize(location_type, location)
      @location = location
      @location_type = location_type
      @brewery_db = set_brewery_db
    end

    def results
      if (@location_type == 'state')
        breweries = brewery_db.locations.all(region: @location)
      elsif (@location_type == 'city')
        breweries = brewery_db.locations.all(locality: @location)
      end

      brewery_arr = []
      breweries.each do |b|
        content = {}
        content['name'] = b.brewery.name
        content['id'] = b.breweryId
        content['website'] = b.brewery.website
        brewery_arr << content
      end

      return brewery_arr
    end

    private
    def set_brewery_db
      @brewery_db = BreweryDB::Client.new do |config|
        config.api_key = ENV['API_KEY']
      end
    end
  end
end
