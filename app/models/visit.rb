class Visit < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant

  validates :visited_at, presence: true
  validates :restaurant_id, uniqueness: { scope: :user_id }
end