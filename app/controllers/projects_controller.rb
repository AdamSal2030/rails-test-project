class ProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]
  def create 
    @project=Project.new(project_params)
    if @project.save
      respond_to do |format|
        format.json
      end
    else
      respond_to do |format|
        format.json { render json: { message: "Failure to create", errors: @member.errors }}
      end
    end
  end

  def update
    @project=Project.find(params[:id])
    @project.name=params[:name]
    if @project.save
      respond_to do |format|
        format.json
      end
    else
      respond_to do |format|
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @project=Project.all
    respond_to do |format|
      format.json
    end
  end

  def show
    @project=Project.find(params[:id])
    respond_to do |format|
      format.json
    end
  end

  def destroy
    @project=Project.find(params[:id])
    @project.destroy
    respond_to do |format|
      format.json
    end
  end



  private
  def project_params
    params.require(:project).permit(:name) 
  end


end
