class V1::OrganizationsController < V1::ApplicationController
  def index
    render(json: Organization.all, status: :ok)
  end

  def show
    @organizations = Organization.find(params[:id])

    render(json: @organizations, include: [:deputies], status: :ok)
  end
end
