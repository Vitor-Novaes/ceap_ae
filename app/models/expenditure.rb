class Expenditure < ApplicationRecord
  RECEIPT_TYPE = %w[INVOICE RECEIPT NO_SPECIFIED NO_SPECIFIED2 EXPENSES_ABROAD].freeze
  enum receipt_type: %i[INVOICE RECEIPT NO_SPECIFIED NO_SPECIFIED2 EXPENSES_ABROAD]

  belongs_to :deputy
  belongs_to :category # TODO Save more attributes to different categories

  validates_associated :deputy
  validates_associated :category
  validates :receipt_type, inclusion: { in: RECEIPT_TYPE }, presence: true
  validates :period, presence: true

  scope :by_organization, lambda { |params|
    joins(deputy: :organization)
      .where(organization: { abbreviation: params[:organization] })
  }

  scope :by_category, lambda { |params|
    joins(:category)
      .where(category: { name: params[:category] })
  }

  scope :sort_value, lambda { |params|
    group(:id).order("sum(net_value) #{params[:sort_value] || 'DESC'}")
  }

  scope :by_deputy, lambda { |params|
    joins(:deputy)
      .where(deputy: { id: params[:deputy] })
  }

  def self.map_term(key)
    {
      start_date: { term: ' date >= :start_date ', type: 'date' },
      end_date: { term: ' date <= :end_date ', type: 'date' },
      provider: { term: ' provider ILIKE :provider ', type: 'string' }
    }[key]
  end

  def self.map_scope(key)
    {
      organization: 'by_organization',
      category: 'by_category',
      deputy: 'by_deputy',
      sort_value: 'sort_value'
    }[key]
  end
end
