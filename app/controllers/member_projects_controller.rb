class MemberProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  def create
    @project = Project.find(params[:project_id])
    @member = Member.find(params[:member_id])

    if @project.members.include?(@member)
      render json: { message: "Member is already part of the project" }, status: :unprocessable_entity
    else
      if @project.members << @member
        respond_to do |format|
          format.json
        end
      else
        render json: { message: "Failed to add member to project" }
      end
    end
  end

  def index
    @project = Project.find_by(id: params[:project_id])
    @member=@project.members
    respond_to do |format|
      format.json
    end
  end

  def record_not_found
    render json: { message: "Record not found " }
  end

end
