class AddStatusToSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :submissions, :status, :string
  end
end
