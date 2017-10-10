class CreateUsersUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users_users do |t|
      t.string :nickname, null: false
      t.string :email, null: false, index: true
      t.string :password_digest, null: false
      t.string :role, null: false

      t.timestamps
    end
  end
end
