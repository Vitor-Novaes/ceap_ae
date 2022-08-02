class ChangeTypeIdeFromDeputy < ActiveRecord::Migration[7.0]
  def up
    change_column :deputies, :ide, :string, null: false, unique: true
    change_column :deputies, :parlamentary_card, :string, null: false, unique: true
  end

  def down
    change_column :deputies, :ide, :bigint, null: false, unique: true
    change_column :deputies, :parlamentary_card, :bigint, null: false, unique: true
  end
end
