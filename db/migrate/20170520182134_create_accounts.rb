class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :username
      t.string :password
      t.references :contest
      t.boolean :admin

      t.timestamps
    end
  end
end
