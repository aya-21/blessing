class Event < ApplicationRecord
  belongs_to :user

  validates :event_name, presence: true
  validates :date_at, presence: true
end