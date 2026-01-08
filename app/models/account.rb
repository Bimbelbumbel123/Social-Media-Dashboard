class Account < ApplicationRecord
  has_many :stats, dependent: :destroy
  belongs_to :platform, optional: true

  validates :username, presence: true
  validates :platform_user_id, presence: true, uniqueness: { scope: :platform_id }
end
