class UpdateExpenditures < ActiveRecord::Migration[7.0]
  def up
    change_column :expenditures, :net_value, :decimal, precision: 8, scale: 2, null: false
    change_column :expenditures, :receipt_type, :integer, using: 'receipt_type::integer', null: false, default: 0
    remove_column :expenditures, :description
  end

  def down
    change_column :expenditures, :net_value, :float
    change_column :expenditures, :receipt_type, :string
    add_column :expenditures, :description, null: false
  end
end
