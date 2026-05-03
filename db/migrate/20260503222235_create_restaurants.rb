class CreateRestaurants < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurants do |t|
      t.string :hotpepper_id
      t.string :name
      t.string :address
      t.string :genre
      t.string :area
      t.string :budget
      t.string :photo_url
      t.string :url

      t.timestamps
    end
  end
end
