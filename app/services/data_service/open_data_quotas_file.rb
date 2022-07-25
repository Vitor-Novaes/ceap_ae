require 'zip'

module DataService
  class OpenDataQuotasFile
    include HTTParty

    BASE_URI = 'https://www.camara.leg.br/cotas'

    def download_by_year(year)
      zip_file = HTTParty.get("#{BASE_URI}/Ano-#{year}.csv.zip").body

      unzip_file(zip_file, year)
    end

    private

    def unzip_file(zip_file, year)
      input_stream = Zip::File.open_buffer(zip_file)
      input_stream.each do |file|
        File.open("tmp/#{year}.csv", 'w') { |f| f.write(file.get_input_stream.read.force_encoding('UTF-8')) }
      end

      File.open("tmp/#{year}.csv", 'r')
    end
  end
end
