class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :full_name, null: false
      t.integer :role, null: false
      t.string :email, null: false

      t.timestamps
    end
  end
end
