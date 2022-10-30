# == Schema Information
#
# Table name: documents
#
#  id                :bigint           not null, primary key
#  description       :string(255)      not null
#  documentable_type :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  documentable_id   :bigint           not null
#  project_id        :bigint           not null
#
# Indexes
#
#  index_documents_on_documentable  (documentable_type,documentable_id)
#  index_documents_on_project_id    (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class Document < ApplicationRecord
  belongs_to :project
  belongs_to :documentable, polymorphic: true

  validates :description, presence: { message: ERROR[:description_presence] },
                          length: { maximum: 200, message: ERROR[:description_length] }
  validates :documentable_id, presence: { message: ERROR[:documentable_presence] }
  validates :project_id, presence: { message: ERROR[:project_presence] }
end
