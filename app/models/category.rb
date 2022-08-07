class Category < ApplicationRecord
  has_many :expenditures

  validates :name, presence: true, uniqueness: true

  scope :sort_spent, lambda { |params|
    joins(:expenditures)
      .group('id')
      .order("sum(expenditures.net_value) #{params[:total_spent] || 'DESC'}")
  }

  def self.map_term(key)
    { name: { term: ' name ILIKE :name ', type: 'string' } }[key]
  end

  def self.map_scope(key)
    { total_spent: 'sort_spent' }[key]
  end
end
