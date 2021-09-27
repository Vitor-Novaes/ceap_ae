class V1::OrganizationsController < V1::ApplicationController
  def index
    render(json: Organization.all, status: :ok)
  end

  def show
    organizations = Organization.includes(:deputies).find(params[:id])

    render(json: organizations.serializable_hash(include: [:deputies]), status: :ok)
  end
end
