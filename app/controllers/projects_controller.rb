# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[update show destroy]

  def create
    @project = Project.new(create_params)
    @project.save!
  end

  def update
    @project.update!(create_params)
  end

  def index
    @project = Project.all
  end

  def show
    @project
  end

  def destroy
    @project.destroy
  end

  private

  def create_params
    params.require(:project).permit(:name)
  end

  def set_project
    @project = Project.find(params[:id])
  end
end
