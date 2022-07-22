module V1
  class OrganizationsController < ApplicationController
    def index
      render json: OrganizationBlueprint.render(
        Organization.last(10),
        view: :summary
      ), status: :ok
    end

    def show
      render json:
        OrganizationBlueprint.render(
                                      Organization.find(params[:id]),
                                      view: :extended
                                    ), status: :ok
    end
  end
end
