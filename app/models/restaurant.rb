class Restaurant < ApplicationRecord
  validates :hotpepper_id, uniqueness: true
end
