# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[7.0]
  def up
    create_table :organizations do |t|
      t.string :abbreviation

      t.timestamps
    end
  end

  def down
    drop_table :organizations
  end
end
