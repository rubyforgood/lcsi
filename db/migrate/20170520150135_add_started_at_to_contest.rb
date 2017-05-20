class AddStartedAtToContest < ActiveRecord::Migration[5.1]
  def change
    add_column :contests, :started_at, :timestamp
  end
end
