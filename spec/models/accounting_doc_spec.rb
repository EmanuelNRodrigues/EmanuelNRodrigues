# == Schema Information
#
# Table name: accounting_docs
#
#  id         :bigint           not null, primary key
#  date       :date
#  value      :decimal(10, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe(AccountingDoc, type: :model) do
  describe 'associations' do
    it { is_expected.to(have_one(:document)) }
  end
end
