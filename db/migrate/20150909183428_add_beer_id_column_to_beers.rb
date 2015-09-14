class AddBeerIdColumnToBeers < ActiveRecord::Migration
  def change
    add_column :beers, :beer_id, :string
    add_index :beers, :beer_id, :unique => true
  end
end
