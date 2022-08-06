module V1
  class ExpendituresController < ApplicationController
    def index
      expenditures = filter_source(Expenditure, params)

      render json: ExpenditureBlueprint.render(
        paginate(expenditures, per_page: params[:per_page], page: params[:page]),
        view: :summary,
        root: :expenditures,
        meta: {
          total_expenses: report_expenses(expenditures)
        }
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
