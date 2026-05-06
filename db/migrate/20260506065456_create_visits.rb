class CreateVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :visits do |t|
      t.references :user,       null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true
      t.date :visited_at,       null: false

      t.timestamps
    end

    add_index :visits, [:user_id, :restaurant_id], unique: true
  end
end