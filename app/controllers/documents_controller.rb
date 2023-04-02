# frozen_string_literal: true

# Handles the documents requests. Must pass a document_type on the URL
class DocumentsController < ApplicationController
  class DocumentError < StandardError; end
  before_action :check_document_type
  before_action :fetch_document, only: %i[show update destroy]

  # GET /users/:user_id/projects/:project_id/documents/:document_type
  def index
    documents = @document_type.where(project_id:)

    render status: :ok,
           json: documents
  end

  # POST /users/:user_id/projects/:project_id/documents/:document_type
  def create
    new_document = @document_type.create(permited_params)

    if new_document.validate
      render status: :created,
             json: Message::INFO[:document_create]
    else
      render status: :unprocessable_entity,
             json: new_document.errors.messages
    end
  end

  # GET /users/:user_id/projects/:project_id/documents/:document_type/:id
  def show
    if @document
      render status: :ok,
             json: @document
    else
      render status: :not_found,
             json: Message::ERROR[:document_show]
    end
  end

  # PUT /users/:user_id/projects/:project_id/documents/:document_type/:id
  def update
    @document.update(permited_params)

    if @document.validate
      render status: :ok,
             json: @project
    else
      render status: :unprocessable_entity,
             json: @document.errors.messages
    end
  end

  # DELETE /users/:user_id/projects/:project_id/documents/:document_type/:id
  def destroy
    if @document_type.destroy(@document.id)
      render status: :ok,
             json: Message::INFO[:document_delete]
    else
      render status: :unprocessable_entity,
             json: Message::ERROR[:document_delete]
    end
  end

  # GET /users/:user_id/projects/:project_id/documents/:document_type/:id/export
  def export; end

  private

  def check_document_type
    @document_type = params.require(:document_type).camelcase.constantize
    return if Document::TYPES.include?(@document_type)

    raise DocumentError Message::ERROR[:document_type]
  end

  def fetch_document
    @document = @document_type.find(params.required(:id))
  end

  def permited_params
    variable_params = {
      accounting_doc: %i[date value],
      architect_office_doc: %i[],
      government_doc: %i[date entity],
      project_doc: %i[version]
    }.freeze

    params.permit(variable_params[params.require(:document_type)])
          .merge(project_id: params.require(:project_id))
  end

  def project_id
    params.require(:project_id)
  end
end
