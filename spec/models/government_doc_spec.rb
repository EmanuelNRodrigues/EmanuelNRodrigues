# == Schema Information
#
# Table name: government_docs
#
#  id         :bigint           not null, primary key
#  date       :date
#  entity     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe GovernmentDoc, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
