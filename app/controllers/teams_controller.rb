class TeamsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def show
    @team=Team.find(params[:id])
    respond_to do |format|
      format.json
    end
  end
  def index
    @teams=Team.all
    respond_to do |format|
      format.json
    end
  end

  def update
    @teams=Team.find(params[:id])
    @teams.update!(team_params)
    respond_to do |format|
      format.json
    end
  end



  def destroy
    @teams=Team.find(params[:id])
    @teams.destroy
    respond_to do |format|
      format.json
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

  private

  def team_params
    params.require(:team).permit(:name) 
  end
      

    
  def new
    @team=Team.new
    render :new
  end

end
