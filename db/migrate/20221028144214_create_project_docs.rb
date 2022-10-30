class CreateProjectDocs < ActiveRecord::Migration[7.0]
  def change
    create_table :project_docs do |t|
      t.string :version

      t.timestamps
    end
  end
end
