class CreateBeers < ActiveRecord::Migration
  def change
    create_table :beers do |t|
      t.string :title
      t.integer :brewery
      t.string :type
      t.string :image
      t.timestamps null: false
    end
  end
end
