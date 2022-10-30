# == Schema Information
#
# Table name: architect_office_docs
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ArchitectOfficeDoc < ApplicationRecord
  has_one :document, as: :documentable
end
