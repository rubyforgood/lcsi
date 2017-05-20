class RemovePassedFromSubmission < ActiveRecord::Migration[5.1]
  def change
    remove_column :submissions, :passed, :boolean
  end
end
