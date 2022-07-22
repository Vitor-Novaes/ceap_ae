module V1
  class ExpendituresController < ApplicationController
    # at_least_for_now
    def import_data
      Populate::RemoteSource.new.download_data

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
