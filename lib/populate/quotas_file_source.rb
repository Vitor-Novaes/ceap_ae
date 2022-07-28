
module Populate
  class QuotasFileSource
    def initialize(file)
      @csv = nil
      @header = {}
      @file = file
    end

    def execute
      @csv = Roo::CSV.new(
        @file,
        csv_options: { col_sep: ';', encoding: 'bom|utf-8', liberal_parsing: true }
      ).sheet(0)

      @csv.each.with_index do |row, index|
        header_mapper(row) if index == 0
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

    def cell(key)
      @row.at(@header.fetch(key))
    end

    def header_mapper(row)
      row.each_index do |index|
        case row[index]
        when /txNomeParlamentar/
          @header.store(:deputy_name, index)
        when /cpf/
          @header.store(:deputy_cpf, index)
        when /ideCadastro/
          @header.store(:deputy_ide, index)
        when /nuCarteiraParlamentar/
          @header.store(:deputy_parlamentary_card, index)
        when /sgUF/
          @header.store(:deputy_state, index)
        when /sgPartido/
          @header.store(:organization_abbreviation, index)
        when /txtDescricaoEspecificacao/
          @header.store(:expenditure_especification, index)
        when /txtDescricao/
          @header.store(:category_name, index)
        when /txtFornecedor/
          @header.store(:expenditure_provider, index)
        when /txtCNPJCPF/
          @header.store(:expenditure_provider_documentation, index)
        when /indTipoDocumento/
          @header.store(:expenditure_receipt_type, index)
        when /datEmissao/
          @header.store(:expenditure_date, index)
        when /vlrLiquido/
          @header.store(:expenditure_net_value, index)
        when /numAno/
          @header.store(:expenditure_period, index)
        when /urlDocumento/
          @header.store(:expenditure_receipt_url, index)
        end
      end
    end

    def ceara?
      cell(:deputy_state).match(/CE/)
    end

    def deputy_name_is_valid?
      !cell(:deputy_name).empty? || !cell(:deputy_name).match(/LIDERANÇA/) || !cell(:deputy_name).match(/LIDMIN/)
    end

    def check_deputy_data(organization)
      if deputy_name_is_valid?
        Deputy.where(cpf: cell(:deputy_cpf)).first_or_create(
          cpf: cell(:deputy_cpf),
          ide: cell(:deputy_ide),
          parlamentary_card: cell(:deputy_parlamentary_card),
          name: cell(:deputy_name),
          state: cell(:deputy_state),
          organization: organization
        )
      end
    end

    def create_expenditure(deputy)
      category = Category.where(name: cell(:category_name)).first_or_create(name: cell(:category_name))

      check_expenditure.first_or_create!(
        especification: cell(:expenditure_especification),
        provider: cell(:expenditure_provider),
        provider_documentation: cell(:expenditure_provider_documentation),
        receipt_type: define_receipt_type,
        date: cell(:expenditure_date),
        net_value: net_value_definition,
        period: cell(:expenditure_period),
        receipt_url: cell(:expenditure_receipt_url),
        deputy: deputy,
        category: category
      )
    end

    def define_receipt_type
      receipt = cell(:expenditure_receipt_type).to_i
      if receipt.between?(0,4)
        return receipt
      end

      2
    end

    def define_date_expenditure
      unless cell(:expenditure_date).nil? || cell(:expenditure_date).empty?
        date = Time.parse(cell(:expenditure_date))
        return Time.new(date.year, date.month, date.day, date.hour, date.min, date.sec, "-03:00")
      end

      nil
    end

    def check_belongs_organization
      if cell(:organization_abbreviation).empty?
        Organization.where(abbreviation: 'SEM PARTIDO').first_or_create(abbreviation: 'SEM PARTIDO')
      else
        Organization
          .where(abbreviation: cell(:organization_abbreviation))
          .first_or_create(abbreviation: cell(:organization_abbreviation))
      end
    end

    def net_value_definition
      return (cell(:expenditure_net_value).to_f.ceil(2) * -1) if cell(:expenditure_net_value).to_f.negative?

      cell(:expenditure_net_value).to_f.ceil(2)
    end

    def check_expenditure
      Expenditure.where(
        especification: cell(:expenditure_especification),
        provider: cell(:expenditure_provider),
        date: define_date_expenditure,
        net_value: net_value_definition,
        receipt_url: cell(:expenditure_receipt_url)
      )
    end
  end
end
