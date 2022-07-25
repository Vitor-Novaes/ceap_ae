module V1
  class ExpendituresController < ApplicationController

    def import_stream_data
      file = $quotas_file_service.download_by_year(Time.now.year)
      Populate::QuotasFileSource.new(file).execute

      render json: { message: 'successfully imported' }
    end

    # TODO validations
    def import_data
      Populate::QuotasFileSource.new(params[:file]).execute

      render json: { message: 'successfully imported' }
    end

    # at_least_for_now
    def index
      render json: ExpenditureBlueprint.render(
        Expenditure.all.last(10),
        view: :summary
      ), status: :ok
    end

    def show
      render json: ExpenditureBlueprint.render(
        Expenditure.find(params[:id]),
        view: :extended
      ), status: :ok
    end
  end
end
