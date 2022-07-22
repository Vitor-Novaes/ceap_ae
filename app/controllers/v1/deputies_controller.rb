module V1
  class DeputiesController < ApplicationController
    def index
      render json: DeputyBlueprint.render(
        Deputy.last(10),
        view: :summary
      ), status: :ok
    end

    def show
      render json: DeputyBlueprint.render(
        Deputy.joins(:expenditures)
          .order('expenditures.net_value desc')
          .find(params[:id]),
        view: :extended
      ), status: :ok
    end
  end
end
