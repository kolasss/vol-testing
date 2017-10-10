class CreateUsersAuthentications < ActiveRecord::Migration[5.1]
  def change
    create_table :users_authentications do |t|
      t.integer :user_id, index: true, null: false
      t.json :info

      t.timestamps
    end

    add_foreign_key :users_authentications, :users_users, column: :user_id
  end
end
