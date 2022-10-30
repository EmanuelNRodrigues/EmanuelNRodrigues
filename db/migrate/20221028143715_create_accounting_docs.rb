class CreateAccountingDocs < ActiveRecord::Migration[7.0]
  def change
    create_table :accounting_docs do |t|
      t.decimal :value, precision: 10, scale: 2
      t.date :date

      t.timestamps
    end
  end
end
