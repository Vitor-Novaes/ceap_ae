# WIP
module DataService
  class OpenData
    include HTTParty

    BASE_URI = 'https://dadosabertos.camara.leg.br/api/v2'

    def deputy_details(deputy_id)
      response = HTTParty.get("#{BASE_URI}/deputados/#{deputy_id}")

      return [:error, reason: :invalid_response] if response.status != 200

      response.body
    end
  end
end
