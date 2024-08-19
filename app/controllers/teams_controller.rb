class TeamsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity


  def show
    @team=Team.find_by(id: params[:id])
    if@team
      respond_to do |format|
        format.json
      end
    else
      respond_to do |format|
        format.json {render json: {message: "Team not found"}}
      end
    end
      
  end
  def index
    @teams=Team.all
    if@teams.count==0
      respond_to do |format|
        format.json {render json: {message: "No team found"}, status: :not_found}
      end
    else
      respond_to do |format|
        format.json 
      end
    end
  end

  def update
    @teams=Team.find_by(id: params[:id])
    if @teams
      @teams.update!(team_params)
      respond_to do |format|
        format.json
      end
    else
      respond_to do |format|
        format.json {render json: {message: "No team with this id exist"}}
      end
    end
  end



  def destroy
    @teams=Team.find_by(id: params[:id])
    if @teams
      @teams.destroy
      respond_to do |format|
        format.json
      end
    else
      respond_to do |format|
        format.json {render json: {message: "No team with this id exist"}}
      end
    end
  end

  def create
    @team = Team.new(team_params) 
    if @team.save
      respond_to do |format|
        format.json { render json: @team, status: :created }
      end
    else
      respond_to do |format|
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def render_unprocessable_entity(exception)
    render json: { message: exception.message }, status: :unprocessable_entity
  end

  private

  def team_params
    params.require(:team).permit(:name) 
  end
      

 

 

end
