class Deputy < ApplicationRecord
  belongs_to :organization
  has_many :expenditures
  validates_associated :organization

  validates :cpf, :ide, :parlamentary_card, :name, :state, presence: true
  validates :cpf, :ide, :parlamentary_card, uniqueness: true

  scope :by_organization, lambda { |params|
    joins(:organization)
      .where(organization: { abbreviation: params[:organization] })
  }

  scope :sort_spent, lambda { |params|
    joins(:expenditures)
      .group('id')
      .order("sum(expenditures.net_value) #{params[:total_spent] || 'DESC'}")
  }

  def total_expense
    self.expenditures.sum(:net_value).ceil(2)
  end
end
