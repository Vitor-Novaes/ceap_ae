class Deputy < ApplicationRecord
  belongs_to :organization
  has_many :expenditures
end
