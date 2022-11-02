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

RSpec.describe(Document, type: :model) do
  describe 'validations' do
    subject { build(:document) }
    let(:project) { create(:project) }

    it { is_expected.to(validate_presence_of(:description).with_message(Message::ERROR[:description_presence])) }
    it {
      is_expected.to(validate_length_of(:description).is_at_most(200).with_message(Message::ERROR[:description_length]))
    }
    it { is_expected.to(validate_presence_of(:documentable_id).with_message(Message::ERROR[:documentable_presence])) }
    it { is_expected.to(validate_presence_of(:project_id).with_message(Message::ERROR[:project_presence])) }
  end

  describe 'associations' do
    it { is_expected.to(belong_to(:project).class_name(Project.name)) }
    it { is_expected.to(belong_to(:documentable)) }
  end
end
