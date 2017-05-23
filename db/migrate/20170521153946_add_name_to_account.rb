class AddNameToAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :name, :string
  end
end
