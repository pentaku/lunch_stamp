class AddUniqueIndexToRestaurantsHotpepperId < ActiveRecord::Migration[7.0]
  def change
    add_index :restaurants, :hotpepper_id, unique: true
  end
end
