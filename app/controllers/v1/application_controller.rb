class V1::ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :render_parameter_missing

  private

  def render_parameter_missing(exception)
    render(json: { error: exception }, status: :unprocessable_entity)
  end
end
