class Event < ApplicationRecord
  belongs_to :user
  has_many :cards

  validates :event_name, presence: true
  validates :date_at, presence: true
end