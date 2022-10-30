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
class AccountingDoc < ApplicationRecord
  has_one :document
end
