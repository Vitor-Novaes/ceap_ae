class V1::ExpendituresController < V1::ApplicationController
  # Better way: Download file from dadosabertos and populate with rake task
  def import_data
    Expenditure.import_from_csv(import_params)

    render(json: { message: 'successfully imported' })
  rescue Exception => e
    render(json: { error: e }, status: :bad_request)
  end

  private

  def import_params
    params.require(:file)
  end
end
