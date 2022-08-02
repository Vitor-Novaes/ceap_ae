module V1
  class OrganizationsController < ApplicationController
    def index
      orgs = paginate Organization.order(abbreviation: 'ASC'),
        per_page: params[:per_page],
        page: params[:page]

      render json: OrganizationBlueprint.render(
        orgs,
        view: :summary
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
