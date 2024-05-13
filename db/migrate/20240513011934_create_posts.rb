# frozen_string_literal: true

# Migration file for creating table of posts.
class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body, null: false
      t.string :ip, null: false

      t.timestamps
    end
  end
end
