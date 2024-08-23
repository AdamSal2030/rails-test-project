# frozen_string_literal: true

module Projects
  class MembersController < ApplicationController
    before_action :set_project, only: %i[create index]

    def create
      @member = Member.find(params[:member_id])

      if @project.members.include?(@member)
        return render json: { message: 'Member is already part of the project' }, status: :unprocessable_entity
      end

      @project.members << @member
      render json: { message: 'Member succesfully added' }, status: :ok
    end

    def index
      @member = @project.members
    end

    private

    def set_project
      @project = Project.find(params[:project_id])
    end
  end
end
