class Stat < ApplicationRecord
  belongs_to :account

  validates :date, presence: true
end
