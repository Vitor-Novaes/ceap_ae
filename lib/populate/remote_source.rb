require 'zip'

# WIP
module Populate
  class RemoteSource
    include HTTParty

    def initialize
      @base_uri = 'https://www.camara.leg.br/cotas'
      @csv = nil
    end

    def download_data
      zip_file = HTTParty.get("#{@base_uri}/Ano-2022.csv.zip").body

      file = unzip_file(zip_file)

      @csv = Roo::CSV.new(
        file,
        csv_options: { col_sep: ';', encoding: 'bom|utf-8', liberal_parsing: true }
      ).sheet(0)

      @csv.each.with_index do |row, index|
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

    def unzip_file(zip_file)
      input_stream = Zip::File.open_buffer(zip_file)
      input_stream.each do |file|
        File.open('tmp/2022.csv', 'w') { |f| f.write(file.get_input_stream.read.force_encoding('UTF-8')) }
      end

      File.open('tmp/2022.csv', 'r')
    end

    def cell(key)
      map = {
        deputy_name: 0,
        deputy_cpf: 1,
        deputy_ide: 2,
        deputy_parlamentary_card: 3,
        deputy_state: 5,
        organization_abbreviation: 6,
        category_name: 9,
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

    def ceara?
      cell('deputy_state').match(/CE/)
    end

    def deputy_name_is_valid?
      !cell('deputy_name').empty? || !cell('deputy_name').match(/LIDERANÇA/) || !cell('deputy_name').match(/LIDMIN/)
    end

    def check_deputy_data(organization)
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

    def create_expenditure(deputy)
      category = Category.where(name: cell('category_name')).first_or_create(name: cell('category_name'))

      check_expenditure.first_or_create!(
        especification: cell('expenditure_especification'),
        provider: cell('expenditure_provider'),
        provider_documentation: cell('expenditure_provider_documentation'),
        receipt_type: define_receipt_type,
        date: cell('expenditure_date'),
        net_value: net_value_definition,
        period: cell('expenditure_period'),
        receipt_url: cell('expenditure_receipt_url'),
        deputy: deputy,
        category: category
      )
    end

    def define_receipt_type
      receipt = cell('expenditure_receipt_type').to_i
      if receipt.between?(0,4)
        return receipt
      end

      2
    end

    def define_date_expenditure
      unless cell('expenditure_date').empty? || cell('expenditure_date').nil?
        date = Time.parse(cell('expenditure_date'))
        return Time.new(date.year, date.month, date.day, date.hour, date.min, date.sec, "-03:00")
      end

      nil
    end

    def check_belongs_organization
      if cell('organization_abbreviation').empty?
        Organization.where(abbreviation: 'SEM PARTIDO').first_or_create(abbreviation: 'SEM PARTIDO')
      else
        Organization
          .where(abbreviation: cell('organization_abbreviation'))
          .first_or_create(abbreviation: cell('organization_abbreviation'))
      end
    end

    def net_value_definition
      return (cell('expenditure_net_value').to_f.ceil(2) * -1) if cell('expenditure_net_value').to_f.negative?

      cell('expenditure_net_value').to_f.ceil(2)
    end

    def check_expenditure
      Expenditure.where(
        especification: cell('expenditure_especification'),
        provider: cell('expenditure_provider'),
        date: define_date_expenditure,
        net_value: net_value_definition,
        receipt_url: cell('expenditure_receipt_url')
      )
    end
  end
end
