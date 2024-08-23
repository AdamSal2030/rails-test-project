# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :set_team, only: %i[update show destroy]

  def show
    @teams
  end

  def index
    @teams = Team.all
  end

  def update
    @teams.update!(create_params)
  end

  def destroy
    @teams.destroy
  end

  def create
    @team = Team.new(create_params)
    @team.save!
  end

  private

  def create_params
    params.require(:team).permit(:name)
  end

  def set_team
    @teams = Team.find(params[:id])
  end
end
