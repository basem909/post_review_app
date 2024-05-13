# frozen_string_literal: true

# Migration file for creating table of users.
class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :login, null: false

      t.timestamps
    end
  end
end
