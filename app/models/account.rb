class Account < ApplicationRecord
  belongs_to :user
  belongs_to :platform
  has_many :stats
end
