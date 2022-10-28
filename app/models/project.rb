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
  validates :name, presence: { message: 'O nome é obrigatório' },
                   length: { maximum: 50, message: 'Superou o número máximo de 50 caracteres' }
  validates :start_date, presence: { message: 'Deve especificar uma data de início' }
  validates :user_id, presence: { message: 'Deve ter um cliente associado' }
  validate :validate_end_date, on: :save

  def validate_end_date
    return unless end_date.present? && end_date > start_date

    raise StandardError('A data de fim deve ser posterior à data de início')
  end
end
