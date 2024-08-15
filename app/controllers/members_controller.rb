class MembersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def destroy
    @member=Member.find(params[:id])
    @member.destroy
    respond_to do |format|
      format.json {render json: { message:"memeber destroyed"}}
    end
  end

  def index
    @member=Member.all
    if @member.count==0
      format.json {render json: { message: "no member found "}}
  
    else
    respond_to do |format|
      format.json
    end
    end
  end

  def show
    @members = Member.where(team_id: params[:team_id])
    respond_to do |format|
      format.json
    end
  end

  def update
    @member = Member.find(params[:id])

    if @member.update(member_params)
      respond_to do |format|
        format.json { render json: @member, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @member = Member.new(member_params.merge(team_id: params[:team_id]))
    if @member.save
      respond_to do |format|
        format.json { render json: @member, status: :created }
      end
    else
      respond_to do |format|
        format.json { render json: { message: "Failure to create", errors: @member.errors }}
      end
    end
  end

  private

  def member_params
    params.require(:member).permit(:first_name, :last_name, :city, :state, :country)
  end


end
