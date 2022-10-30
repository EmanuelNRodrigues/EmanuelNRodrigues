class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :description, null: false
      t.references :project, null: false, foreign_key: true
      t.references :documentable, null: false, polymorphic: true, index: true

      t.timestamps
    end
  end
end
