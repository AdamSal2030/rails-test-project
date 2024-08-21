class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def render_unprocessable_entity(exception)
    render json: { message: exception.message }, status: :unprocessable_entity
  end
  
  def record_not_found
    render json: { message: "Record not found " }
  end
  
  
end
