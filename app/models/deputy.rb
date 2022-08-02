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

  def self.map_term(key)
    {
      name: { term: ' name ILIKE :name ', type: 'string' },
      ide: { term: ' ide LIKE :ide ', type: 'string' },
      parlamentary_card: { term: ' parlamentary_card LIKE :parlamentary_card ', type: 'string' },
      cpf: { term: ' cpf LIKE :cpf ', type: 'string' }
    }[key]
  end

  def self.map_scope(key)
    {
      organization: 'by_organization',
      total_spent: 'sort_spent'
    }[key]
  end
end
