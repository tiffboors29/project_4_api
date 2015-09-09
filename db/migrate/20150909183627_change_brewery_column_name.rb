class ChangeBreweryColumnName < ActiveRecord::Migration
  def change
    rename_column :beers, :brewery, :brewery_id
  end
end
