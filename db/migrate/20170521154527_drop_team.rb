class DropTeam < ActiveRecord::Migration[5.1]
  def change
    drop_table :teams
  end
end
