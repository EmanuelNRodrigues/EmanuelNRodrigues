class CreateArchitectOfficeDocs < ActiveRecord::Migration[7.0]
  def change
    create_table :architect_office_docs do |t|
      t.timestamps
    end
  end
end
