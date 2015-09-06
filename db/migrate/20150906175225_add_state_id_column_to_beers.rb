class AddStateIdColumnToBeers < ActiveRecord::Migration
  def change
    add_column :beers, :state_id, :integer
  end
end
