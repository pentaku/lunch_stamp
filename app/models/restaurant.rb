class Restaurant < ApplicationRecord
  has_many :visits, dependent: :destroy
  has_many :users, through: :visits

  validates :hotpepper_id, presence: true, uniqueness: true
  validates :name, presence: true
end