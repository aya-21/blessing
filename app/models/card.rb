class Card < ApplicationRecord
  belongs_to :user

  validates :card_name, presence: true
  validates :message, presence: true
end