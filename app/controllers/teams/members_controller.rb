# frozen_string_literal: true

module Teams
  class MembersController < ApplicationController
    def index
      @members = Member.where(team_id: params[:team_id])
    end

    def create
      @member = Member.new(create_params.merge(team_id: params[:team_id]))
      @member.save!
    end

    private

    def create_params
      params.require(:member).permit(:first_name, :last_name, :city, :state, :country)
    end
  end
end
