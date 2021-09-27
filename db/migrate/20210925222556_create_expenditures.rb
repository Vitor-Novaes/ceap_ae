class CreateExpenditures < ActiveRecord::Migration[6.0]
  def up
    create_table :expenditures do |t|
      t.text :description, null: false
      t.text :especification
      t.string :provider, null: false
      t.string :provider_documentation, null: false
      t.datetime :date
      t.integer :period, null: false
      t.float :net_value
      t.string :receipt_type
      t.string :receipt_url

      t.references :deputy, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :expenditures
  end
end
