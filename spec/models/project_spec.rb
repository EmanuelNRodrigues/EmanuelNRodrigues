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
end
