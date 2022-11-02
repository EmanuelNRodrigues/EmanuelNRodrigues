# == Schema Information
#
# Table name: architect_office_docs
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe(ArchitectOfficeDoc, type: :model) do
  describe 'associations' do
    it { is_expected.to(have_one(:document)) }
  end
end
