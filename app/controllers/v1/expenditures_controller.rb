module V1
  class ExpendituresController < ApplicationController
    # WIP
    def import_data
      Populate::RemoteSource.new.download_data

      render(json: { message: 'successfully imported' })
    # rescue Exception => e
    #   render(json: { error: e }, status: :bad_request)
    end
  end
end
