# == Schema Information
#
# Table name: projects
#
#  id         :bigint           not null, primary key
#  end_date   :date
#  name       :string(255)      not null
#  start_date :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_projects_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    subject { build(:project) }
    let(:user) { create(:user) }

    it { is_expected.to validate_presence_of(:name).with_message(Message::ERROR[:name_presence]) }
    it { is_expected.to validate_length_of(:name).is_at_most(50).with_message(Message::ERROR[:name_length]) }
    it { is_expected.to validate_presence_of(:start_date).with_message(Message::ERROR[:start_date_presence]) }
    it { is_expected.to validate_presence_of(:user_id).with_message(Message::ERROR[:user_presence]) }

    it 'is expected to accept a null end_date' do
      project = build(:project, end_date: nil, user:)
      expect(project.valid?).to be true
    end

    it 'is expected to accept the end_date after start_date' do
      project = build(:project, start_date: Date.today, end_date: Date.today + 1.day, user:)
      expect(project.valid?).to be true
    end

    it 'is expected to raise error if the end_date is equal or before start_date' do
      project = build(:project, start_date: Date.today, end_date: Date.today - 1.day, user:)
      expect(project.valid?).to be false
      expect(project.errors[:end_date].join).to eq Message::ERROR[:end_date_validation]
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).class_name(User.name) }
  end
end
