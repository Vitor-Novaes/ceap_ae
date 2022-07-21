require 'zip'

module Populate
  module RemoteSource
    include HTTParty
    include DataMapping

    @base_uri = 'https://www.camara.leg.br/cotas'
    @csv = nil

    def self.download_data
      temp_file = HTTParty.get("#{@base_uri}/Ano-2022.csv.zip").body

      zip_file = Zip::File.open_buffer(temp_file)
      zip_file.each do |file|
        @csv = Roo::CSV.new(
          file.get_input_stream.read.force_encoding('UTF-8'),
          csv_options: { col_sep: ';', encoding: 'bom|utf-8' }
        )
      end

      rows = @csv.sheet(0)

      rows.each.with_index do |row, index|
        next if index < 1

        @row = row

        # if ceara?

        #   # build organization
        #   organization = check_belongs_organization

        #   # build deputy
        #   deputy = check_deputy_data(organization)

        #   # build expenditure
        #   create_expenditure(deputy)

        # end

        next
      end
    end
  end
end
# Populate::RemoteSource.download_data
