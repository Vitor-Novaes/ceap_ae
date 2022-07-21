
module Populate
  module DataMapping
    def cell(key)
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

    def check_belongs_organization
      unless cell('organization_abbreviation').empty?
        Organization
          .where(abbreviation: cell('organization_abbreviation'))
          .first_or_create(abbreviation: cell('organization_abbreviation'))
      end
    end

    def receipt_type_definition
      types = {
        '0': 'INVOICE',
        '1': 'RECEIPT',
        # It was supposed to be 2 according to the documentation, but there's no 2 in the data
        '4': 'EXPENSES_ABROAD'
      }

      types[cell('expenditure_receipt_type').to_sym]
    end

    def expendutures_period_registered?(rows)
      !Expenditure.where(period: rows[2][21]).first.nil?
    end

    def net_value_definition
      return (cell('expenditure_net_value').to_f.ceil(2) * -1) if cell('expenditure_net_value').to_f.negative?

      cell('expenditure_net_value').to_f.ceil(2)
    end
  end
end
