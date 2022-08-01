module V1
  class ExpendituresController < ApplicationController
    def index
      expenditures = paginate filter_source(Expenditure, params),
        per_page: params[:per_page],
        page: params[:page]

      render json: ExpenditureBlueprint.render(
        expenditures,
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
