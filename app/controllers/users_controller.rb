# frozen_string_literal: true

# Handles the user requests
class UsersController < ApplicationController
  before_action :fetch_user, only: %i[show update destroy]

  # GET /users
  def index
    users = User.select(:id, :full_name, :role, :email)
    render(status: :ok,
           json: users)
  end

  # POST /users
  def create
    new_user = User.create(permited_params)

    if new_user.validate
      render status: :created,
             json: Message::INFO[:user_create]
    else
      render status: :unprocessable_entity,
             json: new_user.errors.messages
    end
  end

  # GET /users/:id
  def show
    render status: :ok,
           json: @user
  end

  # PUT /users/:id
  def update
    @user.update(permited_params)
    if @user.validate
      render status: :ok,
             json: @user
    else
      render status: :unprocessable_entity,
             json: @user.errors.messages
    end
  end

  # DELETE /users/:id
  def destroy
    if User.destroy(@user.id)
      render status: :ok,
             json: Message::INFO[:user_delete]

    else
      render status: :unprocessable_entity,
             json: Message::ERROR[:user_delete]

    end
  end

  private

  def permited_params
    params.permit(%i[full_name role email])
  end

  def fetch_user
    @user = User.select(:id, :full_name, :role, :email)
                .find(params.required(:id))
  rescue ActiveRecord::RecordNotFound
    render status: :not_found,
           json: ''
  end
end
