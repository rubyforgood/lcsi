class AddAccountIdToSubmission < ActiveRecord::Migration[5.1]
  def change
    rename_column :submissions, :team_id, :account_id
  end
end
