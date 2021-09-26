class CreateDeputies < ActiveRecord::Migration[6.0]
  def up
    create_table :deputies do |t|
      t.string :cpf, null: false, unique: true
      t.bigint :ide, null: false, unique: true
      t.integer :parlamentary_card, null: false, unique: true
      t.string :name, null: false
      t.string :state, null: false

      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :deputies
  end
end
