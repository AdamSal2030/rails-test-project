# frozen_string_literal: true

class AddNotNullToMemberTable < ActiveRecord::Migration[7.1]
  def change
    change_column_null :members, :first_name, false
    change_column_null :members, :last_name, false
  end
end
