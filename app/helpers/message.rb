# frozen_string_literal: true

module Message
  ERROR = {
    email_format: 'O formato do email é inválido',
    email_presence: 'O email é obrigatório',
    email_uniqueness: 'O email já se encontra registado',
    end_date_validation: 'A data de fim deve ser posterior à data de início',
    name_length: 'O nome é demasiado comprido',
    name_presence: 'O nome é obrigatório',
    role_inclusion: 'Tem de escolher uma função de utilizador válida',
    start_date_presence: 'A data de entrada é obrigatória',
    user_presence: 'Deve ter um cliente associado'
  }.freeze
end
