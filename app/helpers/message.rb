# frozen_string_literal: true

module Message
  ERROR = {
    email_format: 'O formato do email é inválido',
    email_presence: 'O email é obrigatório',
    email_uniqueness: 'O email já se encontra registado',
    name_length: 'O nome é demasiado comprido',
    name_presence: 'O nome é obrigatório',
    role_inclusion: 'Tem de escolher uma função de utilizador válida'
  }.freeze
end
