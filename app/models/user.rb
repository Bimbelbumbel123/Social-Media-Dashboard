class User < ApplicationRecord
  has_secure_password
  has_many :accounts
  has_many :platforms, through: :accounts
end
