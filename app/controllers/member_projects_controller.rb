class MemberProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  def create
    @project = Project.find(params[:project_id])
    @member = Member.find(params[:member_id])

    if @project.members << @member
      respond_to do |format|
        format.json
      end
    else
      render json: { message: "Failed to add member to project" }
    end
  end

  def index
    @project = Project.find_by(id: params[:project_id])
    @member=@project.members
    respond_to do |format|
      format.json
    end
  end
end
