class Platform < ApplicationRecord
  has_many :accounts

  validates :platform_name, presence: true, uniqueness: true
end
