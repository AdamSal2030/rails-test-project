# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from StandardError, with: :handle_exception

  def render_unprocessable_entity(exception)
    render json: { message: exception.message }, status: :unprocessable_entity
  end

  def record_not_found
    render json: { message: 'Record not found ' }, status: :not_found
  end
  
end
