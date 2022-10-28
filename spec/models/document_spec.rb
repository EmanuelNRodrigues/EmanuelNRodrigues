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
require 'rails_helper'

RSpec.describe Document, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
