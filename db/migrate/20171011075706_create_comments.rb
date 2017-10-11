class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.datetime :published_at, null: false
      t.belongs_to :post, foreign_key: true, index: true, null: false
      t.integer :author_id, index: true, null: false

      t.timestamps
    end
    add_foreign_key :comments, :users_users, column: :author_id
  end
end
