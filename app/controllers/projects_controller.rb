class ProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]
  def create 
    @project=Project.new(create_params)
    if @project.save
      respond_to do |format|
        format.json
      end
    else
      respond_to do |format|
        format.json { render json: { message: "Failure to create", errors: @project.errors }}
      end
    end
  end

  def update
    @project=Project.find_by(id: params[:id])
    if @project
      if @project.update(create_params)
        respond_to do |format|
          format.json
        end
      else
        respond_to do |format|
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.json {render json: {message: "No project with this id exist"}}
      end
    end      
  end

  def index
    @project=Project.all
    if @project
      respond_to do |format|
        format.json
      end
    else
      respond_to do |format|
        format.json { render json: { message: "No Project exist" }}
      end
    end
  end

  def show
    @project=Project.find_by(id: params[:id])
    if @project
      respond_to do |format|
        format.json
      end
    else
      respond_to do |format|
        format.json {render json: {message: "Project not found"}}
      end
    end
  end

  def destroy
    @project=Project.find_by(id: params[:id])
    if @project
      @project.destroy
      respond_to do |format|
        format.json
      end
    else
      respond_to do |format|
        format.json {render json: {message: "Project not found"}}
      end
    end
  end



  private
  def create_params
    params.require(:project).permit(:name) 
  end


end
