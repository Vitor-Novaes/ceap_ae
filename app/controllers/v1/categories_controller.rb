module V1
  class CategoriesController < ApplicationController
    def index
      categories = filter_source(Category, params)

      render json: CategoryBlueprint.render(
        paginate(categories, per_page: params[:per_page], page: params[:page]),
        root: :categories,
        view: :extended
      ), status: :ok
    end
  end
end
