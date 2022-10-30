class CreateGovernmentDocs < ActiveRecord::Migration[7.0]
  def change
    create_table :government_docs do |t|
      t.string :entity
      t.date :date

      t.timestamps
    end
  end
end
