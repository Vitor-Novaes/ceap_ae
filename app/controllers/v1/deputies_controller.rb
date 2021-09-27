class V1::DeputiesController < V1::ApplicationController
  def index
    render(json: Deputy.all, status: :ok)
  end

  def show
    @deputies = Deputy.includes(:expenditures).order('expenditures.net_value desc').find(params[:id])

    render(json: @deputies, include: [:expenditures], status: :ok)
  end
end
