# frozen_string_literal: true

module Message
  ERROR = {
    description_presence: 'A descrição é obrigatória',
    description_length: 'A descrição é demasiado comprida',
    documentable_presence: 'Deve ter um tipo de documento associado',
    email_format: 'O formato do email é inválido',
    email_presence: 'O email é obrigatório',
    email_uniqueness: 'O email já se encontra registado',
    end_date_validation: 'A data de fim deve ser posterior à data de início',
    name_length: 'O nome é demasiado comprido',
    name_presence: 'O nome é obrigatório',
    project_presence: 'Deve ter um projeto associado',
    role_inclusion: 'Tem de escolher uma função de utilizador válida',
    start_date_presence: 'A data de entrada é obrigatória',
    user_delete: 'Ocorreu um erro a apagar o utilizador',
    user_presence: 'Deve ter um cliente associado'
  }.freeze
  INFO = {
    user_create: 'O utilizador foi criado com sucesso',
    user_update: 'O utilizador foi atualizado com sucesso',
    user_delete: 'O utilizador foi apagado com sucesso'
  }.freeze
end
