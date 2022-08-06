module V1
  class OrganizationsController < ApplicationController
    def index
      orgs = Organization.order(abbreviation: 'ASC')

      render json: OrganizationBlueprint.render(
        paginate(orgs, per_page: params[:per_page], page: params[:page]),
        view: :summary,
        root: :organizations
      ), status: :ok
    end

    # at_least_for_now
    def show
      render json:
        OrganizationBlueprint.render(
          Organization.find(params[:id]),
          view: :extended
        ), status: :ok
    end
  end
end
