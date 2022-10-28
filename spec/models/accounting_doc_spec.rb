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

RSpec.describe AccountingDoc, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
