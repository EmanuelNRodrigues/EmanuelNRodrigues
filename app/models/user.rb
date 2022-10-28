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
class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  enum role: { admin: 0, client: 1 }

  validates :full_name, presence: { message: 'O nome é obrigatório' },
                        length: { maximum: 50, message: 'Superou o número máximo de 50 caracteres' }
  validates :email, presence: { message: 'O email é obrigatório' },
                    format: { with: VALID_EMAIL_REGEX, message: 'O email introduzido não é válido' }
  validates :role, inclusion: { in: roles, message: 'Tem de escolher uma função válida' }
end
