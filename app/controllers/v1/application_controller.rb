module V1
  class ApplicationController < ActionController::API
    include FilterSource
    include Reports

    rescue_from ActionController::ParameterMissing, with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
    rescue_from ActionController::RoutingError, with: :render_not_found_route

    private

    def render_not_found_route(exception)
      render json: { errors: { message: "Route Not Found: #{exception.message}" } }, status: :not_found
    end

    # 404 Not Found Record
    def render_record_not_found(exception)
      render json: { errors: { message: exception.message } }, status: :not_found
    end
  end
end
