# frozen_string_literal: true

class MembersController < ApplicationController
  before_action :set_member, only: %i[update show destroy]

  def destroy
    @member.destroy
  end

  def index
    @member = Member.all
  end

  def show
    @member
  end

  def update
    @member.update!(update_params)
  end

  private

  def update_params
    params.require(:member).permit(:first_name, :last_name, :city, :state, :country)
  end

  def set_member
    @member = Member.find(params[:id])
  end
end
