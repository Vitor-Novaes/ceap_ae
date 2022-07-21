class Expenditure < ApplicationRecord
  RECEIPT_TYPE = %w[INVOICE RECEIPT EXPENSES_ABROAD NO_SPECIFIED].freeze
  enum receipt_type: %i[INVOICE RECEIPT EXPENSES_ABROAD NO_SPECIFIED]

  belongs_to :deputy
  belongs_to :category

  validates_associated :deputy
  validates_associated :category
  validates :receipt_type, inclusion: { in: RECEIPT_TYPE }, presence: true
  validates :period, presence: true

end
