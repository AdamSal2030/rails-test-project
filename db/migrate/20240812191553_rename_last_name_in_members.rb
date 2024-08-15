class RenameLastNameInMembers < ActiveRecord::Migration[7.0]
  def change
    rename_column :members, :Last_name, :last_name
  end
end
