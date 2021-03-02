# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.text :name
      t.string :last_changed

      t.timestamps
    end
  end
end
