# frozen_string_literal: true

class RemoveTeamIdFromTeams < ActiveRecord::Migration[7.1]
  def change
    remove_column :teams, :team_id, :integer
  end
end
