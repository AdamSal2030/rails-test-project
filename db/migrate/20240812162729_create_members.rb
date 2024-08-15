class CreateMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :members do |t|
      t.string :first_name
      t.string :last_name
      t.string :city
      t.string :state
      t.string :country

      t.timestamps
    end
  end
end
