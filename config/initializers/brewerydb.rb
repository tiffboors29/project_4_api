# BreweryDb.configure do |config|
#   config.apikey = ENV['API_KEY']
# end

$brewery_db = BreweryDB::Client.new do |config|
  config.api_key = ENV['API_KEY']
end
