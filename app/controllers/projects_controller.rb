# frozen_string_literal: true

# Handles the project requests
class ProjectsController < ApplicationController
  # GET	/users/:user_id/projects
  def index
    projects = if user_is_admin?
                 Project.select(%w[id name start_date end_date])
               else
                 Project.select(%w[id name start_date end_date])
                        .where(user_id: params.require(:user_id))
               end

    render status: :ok,
           json: projects
  end

  def create
    new_project = Project.create(permited_params.merge(user_id:))

    if new_project.validate
      render status: :created,
             json: Message::INFO[:project_create]
    else
      render status: :unprocessable_entity,
             json: new_project.errors.messages
    end
  end

  private

  def user_is_admin?
    User.find(params.require(:user_id)).role == 'admin'
  end

  def permited_params
    params.permit(%i[id name start_date end_date])
  end

  def user_id
    params.require(:user_id)
  end
end
