class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :beers, :type, :kind
  end
end
