class Card < ApplicationRecord
  mount_uploader :card_image, CardImageUploader

  belongs_to :user
  belongs_to :event

  validates :card_name, presence: true
  validates :message, presence: true
end