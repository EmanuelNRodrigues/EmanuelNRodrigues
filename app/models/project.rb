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
class Project < ApplicationRecord
  belongs_to :user
  has_many :documents

  validates :name, presence: { message: ERROR[:name_presence] },
                   length: { maximum: 50, message: ERROR[:name_length] }
  validates :start_date, presence: { message: ERROR[:start_date_presence] }
  validates :user_id, presence: { message: ERROR[:user_presence] }
  validate :validate_end_date

  def validate_end_date
    return if end_date.blank? || end_date > start_date

    errors.add(:end_date, message: ERROR[:end_date_validation])
  end
end
