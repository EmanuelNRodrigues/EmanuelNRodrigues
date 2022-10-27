class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.integer :status
      t.date :requested_at
      t.date :delivered_at
      t.references :project, null: false, foreign_key: true
      t.references :documentable, null: false, polymorphic: true, index: true

      t.timestamps
    end
  end
end
