module Teams
  class MembersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  
    def index
      @members = Member.where(team_id: params[:team_id])
        if @members
          respond_to do |format|
            format.json { render json: @members}
          end
        else
          respond_to do |format|
            format.json {render json: {message: "No member found"}}
          end
        end
    end
  
  end
end
  
