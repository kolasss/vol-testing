class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.integer :author_id, index: true, null: false
      t.datetime :published_at, null: false

      t.timestamps
    end
    add_foreign_key :posts, :users_users, column: :author_id
  end
end
