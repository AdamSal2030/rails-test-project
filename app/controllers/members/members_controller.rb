class MembersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  def destroy
    @member=Member.find_by(id: params[:id])
    if @member
      @member.destroy
      respond_to do |format|
        format.json {render json: { message:"member destroyed"}}
      end
    else
      respond_to do |format|
        format.json {render json: {message: "Member not found"}}
      end
    end
  end

  def index
    @member=Member.all
     if @member.count==0
        respond_to do |format|
          format.json {render json: { message: "No members found"}, status: :not_found}
        end
      else
        respond_to do |format|
          format.json { render json: @member, status: :ok }
        end
      end
  end

  def show
      @member = Member.find_by(id: params[:id])
      respond_to do |format|
        if @member
          format.json { render json: { first_name: @member.first_name, last_name: @member.last_name }, status: :found }
        else
          format.json { render json: { message: "No member found" }, status: :not_found }
        end
      end
  end
  

  def update
    @member = Member.find_by(id: params[:id])
    if @member
      if @member.update(create_params)
        respond_to do |format|
          format.json
        end
      else
        respond_to do |format|
          format.json { render json: @member.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.json {render json: {message: "Member not found"}, status: :not_found}
      end
    end
  end

  def create
    @member = Member.new(create_params.merge(team_id: params[:team_id]))
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

  def render_unprocessable_entity(exception)
    render json: { message: exception.message }, status: :unprocessable_entity
  end

  private

  def create_params
    params.require(:member).permit(:first_name, :last_name, :city, :state, :country, :team_id)
  end


end
