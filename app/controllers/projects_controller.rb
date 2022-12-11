# frozen_string_literal: true

# Handles the project requests
class ProjectsController < ApplicationController
  before_action :fetch_project, only: %i[show update destroy]

  SHOWABLE_PARAMS = %i[id name start_date end_date].freeze
  # GET	/users/:user_id/projects
  def index
    projects = if user_is_admin?
                 Project.select(SHOWABLE_PARAMS)
               else
                 Project.select(SHOWABLE_PARAMS)
                        .where(user_id:)
               end

    render status: :ok,
           json: projects
  end

  # POST	/users/:user_id/projects
  def create
    new_project = Project.create(permitted_params.merge(user_id:))

    if new_project.validate
      render status: :created,
             json: Message::INFO[:project_create]
    else
      render status: :unprocessable_entity,
             json: new_project.errors.messages
    end
  end

  # GET /users/:user_id/projects/:id
  def show
    if @project
      render status: :ok,
             json: @project
    else
      render status: :not_found,
             json: Message::ERROR[:project_show]
    end
  end

  # PUT /users/:user_id/projects/:id
  def update
    @project.update(permitted_params.merge(user_id:))
    if @project.validate
      render status: :ok,
             json: @project.attributes.slice(SHOWABLE_PARAMS)
    else
      render status: :unprocessable_entity,
             json: @project.errors.messages
    end
  end

  # DELETE /users/:user_id/projects/:id
  def destroy
    if Project.destroy(@project.id)
      render status: :ok,
             json: Message::INFO[:project_delete]
    else
      render status: :unprocessable_entity,
             json: Message::ERROR[:project_delete]
    end
  end

  private

  def user_is_admin?
    User.find(params.require(:user_id)).role == 'admin'
  end

  def permitted_params
    params.permit(SHOWABLE_PARAMS)
  end

  def user_id
    params.require(:user_id)
  end

  def fetch_project
    @project = if user_is_admin?
                 Project.select(SHOWABLE_PARAMS)
                        .find(params.required(:id))
               else
                 Project.select(SHOWABLE_PARAMS)
                        .find_by(id: params.required(:id), user_id:)
               end
  rescue ActiveRecord::RecordNotFound
    render status: :not_found,
           json: ''
  end
end
