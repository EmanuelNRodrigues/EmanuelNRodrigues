# == Schema Information
#
# Table name: project_docs
#
#  id         :bigint           not null, primary key
#  version    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ProjectDoc < ApplicationRecord
  has_one :document, as: :documentable, dependent: :destroy
end
