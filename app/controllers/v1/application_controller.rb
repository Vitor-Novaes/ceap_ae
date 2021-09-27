class V1::ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :render_parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  private

  def render_parameter_missing(exception)
    render(json: { error: exception }, status: :unprocessable_entity)
  end

  def render_record_not_found
    render(json: { error: 'Record not found'}, status: :not_found)
  end

  # Refactor upload
  def ensure_json_request
    return if request.format.json?

    head(:not_acceptable)
  end
end
