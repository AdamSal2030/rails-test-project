# frozen_string_literal: true

class AddNotNullToTeamTable < ActiveRecord::Migration[7.1]
  def change
    change_column_null :teams, :name, false
  end
end
