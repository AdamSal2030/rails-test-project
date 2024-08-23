# frozen_string_literal: true

class ChangeNullConstraintOnMemberProjects < ActiveRecord::Migration[7.1]
  def change
    change_column_null :member_projects, :member_id, true
    change_column_null :member_projects, :project_id, true
  end
end
