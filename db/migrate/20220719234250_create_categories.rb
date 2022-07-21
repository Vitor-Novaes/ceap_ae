class CreateCategories < ActiveRecord::Migration[7.0]
  def up
    create_table :categories do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end

    add_reference :expenditures, :category, index: true, foreign_key: true, null: false
  end

  def down
    remove_reference :expenditures, :category
    drop_table :categories
  end
end
