class V1::DeputiesController < V1::ApplicationController
  def index
    deputies = Deputy.all
    render(json: deputies, status: :ok)
  end

  def show
    deputies = Deputy.includes(:expenditures).order('expenditures.net_value desc').find(params[:id])

    render(
      json: deputies.serializable_hash(include: [:expenditures], methods: %i[expensive_expense total_expense photo_url]),
      status: :ok
    )
  end
end
