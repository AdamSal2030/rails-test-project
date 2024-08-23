# frozen_string_literal: true

class AddTeamToMemeber < ActiveRecord::Migration[7.1]
  def change
    add_reference :members, :team, null: false, foreign_key: true
  end
end
