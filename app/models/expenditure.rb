class Expenditure < ApplicationRecord
  FILE_FORMATS = %w[text/csv].freeze
  RECEIPT_TYPE = %w[INVOICE RECEIPT EXPENSES_ABROAD NO_SPECIFIED].freeze

  belongs_to :deputy
  validates :receipt_type, inclusion: { in: RECEIPT_TYPE }, allow_nil: false

  def self.import_from_csv(file)
    raise('The file must be CSV type') unless FILE_FORMATS.include?(file.content_type)

    csv = Roo::CSV.new(file, csv_options: { col_sep: ';', encoding: 'bom|utf-8' })
    rows = csv.sheet(0)
    raise("The period has already been imported") if expendutures_period_registered?(rows.first(3))

    rows.each.with_index do |row, index|
      next if index < 1
      @row = row

      if ceara?

        # build organization
        organization = check_belongs_organization

        # build deputy
        deputy = check_deputy_data(organization)

        # build expenditure
        create_expenditure(deputy)

      end

      next
    end
  end

  private

  def self.cell(key)
    map = {
      deputy_name: 0,
      deputy_cpf: 1,
      deputy_ide: 2,
      deputy_parlamentary_card: 3,
      deputy_state: 5,
      organization_abbreviation: 6,
      expenditure_description: 9,
      expenditure_especification: 11,
      expenditure_provider: 12,
      expenditure_provider_documentation: 13,
      expenditure_receipt_type: 15,
      expenditure_date: 16,
      expenditure_net_value: 19,
      expenditure_period: 21,
      expenditure_receipt_url: 30
    }

    @row.at(map[key.to_sym])
  end

  def self.ceara?
    cell('deputy_state').match(/CE/)
  end

  def self.deputy_name_is_valid?
    !cell('deputy_name').empty? ||
      !cell('deputy_name').match(/LIDERANÇA/) ||
      !cell('deputy_name').match(/LIDMIN/)
  end

  def self.check_deputy_data(organization)
    if deputy_name_is_valid?
      Deputy.where(cpf: cell('deputy_cpf')).first_or_create(
        cpf: cell('deputy_cpf'),
        ide: cell('deputy_ide'),
        parlamentary_card: cell('deputy_parlamentary_card'),
        name: cell('deputy_name'),
        state: cell('deputy_state'),
        organization: organization
      )
    end
  end

  def self.create_expenditure(deputy)
    Expenditure.create!(
      description: cell('expenditure_description'),
      especification: cell('expenditure_especification'),
      provider: cell('expenditure_provider'),
      provider_documentation: cell('expenditure_provider_documentation'),
      receipt_type: receipt_type_definition,
      date: cell('expenditure_date'),
      net_value: net_value_definition,
      period: cell('expenditure_period'),
      receipt_url: cell('expenditure_receipt_url'),
      deputy: deputy
    )
  end

  def self.check_belongs_organization
    unless cell('organization_abbreviation').empty?
      Organization
        .where(abbreviation: cell('organization_abbreviation'))
        .first_or_create(abbreviation: cell('organization_abbreviation'))
    end
  end

  def self.receipt_type_definition
    types = {
      '0': 'INVOICE',
      '1': 'RECEIPT',
      # It was supposed to be 2 according to the documentation, but there's no 2 in the data
      '4': 'EXPENSES_ABROAD'
     }

    types[cell('expenditure_receipt_type').to_sym]
  end

  def self.expendutures_period_registered?(rows)
    !Expenditure.where(period: rows[2][21]).first.nil?
  end

  def self.net_value_definition
    return (cell('expenditure_net_value').to_f * -1 ) if cell('expenditure_net_value').to_f.negative?

    cell('expenditure_net_value')
  end
end
