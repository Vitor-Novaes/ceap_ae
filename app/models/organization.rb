class Organization < ApplicationRecord
  has_many :deputies

  validates :abbreviation, presence: true
end
