# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string(255)      not null
#  full_name  :string(255)      not null
#  role       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'rails_helper'

RSpec.describe(User, type: :model) do
  describe 'validations' do
    subject { build(:user) }
    it { is_expected.to(validate_presence_of(:full_name).with_message(Message::ERROR[:name_presence])) }
    it { is_expected.to(validate_length_of(:full_name).is_at_most(50).with_message(Message::ERROR[:name_length])) }
    it { is_expected.to(validate_presence_of(:email).with_message(Message::ERROR[:email_presence])) }
    it { is_expected.to(validate_uniqueness_of(:email).with_message(Message::ERROR[:email_uniqueness])) }
    it { is_expected.to(define_enum_for(:role).with_prefix(:role)) }

    it 'is expected to validate that :email has the correct format, producing a custom validation error on failure' do
      user = build(:user)
      %w[test@abc @abc.com test@abc. @abc.com].each do |invalid_email|
        user.email = invalid_email
        expect(user.valid?).to(be(false))
        expect(user.errors[:email].join).to(eq(Message::ERROR[:email_format]))
      end
      %w[123@123.com test@edc.pt].each do |valid_email|
        user.email = valid_email
        expect(user.valid?).to(be(true))
      end
    end
  end
end
