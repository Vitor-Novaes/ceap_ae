module V1
  class DeputiesController < ApplicationController
    def index
      deputies = paginate filter_source(Deputy, params),
        per_page: params[:per_page],
        page: params[:page]

      render json: DeputyBlueprint.render(
        deputies,
        view: :summary
      ), status: :ok
    end

    def show
      render json: DeputyBlueprint.render(
        Deputy.find(params[:id]),
        view: :extended
      ), status: :ok
    end
  end
end
