module V1
  class DeputiesController < ApplicationController
    def index
      deputies = filter_source(Deputy, params);

      render json: DeputyBlueprint.render(
        paginate(deputies, per_page: params[:per_page], page: params[:page]),
        root: :deputies,
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
