class Deputy < ApplicationRecord
  belongs_to :organization
  has_many :expenditures
  validates_associated :organization

  validates :cpf, :ide, :parlamentary_card, :name, :state, presence: true
  validates :cpf, :ide, :parlamentary_card, uniqueness: true

  def expensive_expense
    self.expenditures.first.net_value
  end

  def total_expense
    self.expenditures.sum(:net_value).ceil(2)
  end

  def photo_url
    "http://www.camara.leg.br/internet/deputado/bandep/#{self.ide}.jpg"
  end
end
