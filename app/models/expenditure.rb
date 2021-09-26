class Expenditure < ApplicationRecord
  FILE_FORMATS = %w[.csv].freeze
  belongs_to :deputy

  # TODO implementation
  def self.import_from_csv(file)
    raise('The file CSV is required') unless File.extname(file).include?(accepted_formats_import)
  end
end
