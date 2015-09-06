class AddVotesColumnToBeers < ActiveRecord::Migration
  def change
    add_column :beers, :votes, :integer
  end
end
