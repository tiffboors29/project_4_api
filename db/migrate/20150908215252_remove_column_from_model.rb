class RemoveColumnFromModel < ActiveRecord::Migration
  def change
    remove_column :beers, :kind
    remove_column :beers, :image
  end
end
