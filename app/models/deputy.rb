class Deputy < ApplicationRecord
  belongs_to :organization
  has_many :expenditures

  def expensive_expense
    self.expenditures.first.net_value
  end

  def total_expense
    self.expenditures.sum(:net_value).ceil(2)
  end
end
