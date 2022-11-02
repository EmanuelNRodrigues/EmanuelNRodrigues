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
class User < ApplicationRecord
  has_many :projects

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  enum role: { admin: 0, user: 1 }

  validates :full_name, presence: { message: ERROR[:name_presence] },
                        length: { maximum: 50, message: ERROR[:name_length] }
  validates :email, presence: { message: ERROR[:email_presence] },
                    format: { with: VALID_EMAIL_REGEX, message: ERROR[:email_format] },
                    uniqueness: { case_sensitive: true, message: ERROR[:email_uniqueness] }
end
