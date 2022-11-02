# frozen_string_literal: true

# Handles the user requests
class UserController < ApplicationController
  before_action :fetch_user, only: %i[show update destroy]

  # GET /user
  def index
    users = User.select(:id, :full_name, :role, :email)
    render(status: :ok,
           json: users)
  end

  # POST /user
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

  # GET /user/:id
  def show
    render status: :ok,
           json: @user
  end

  # PUT /user/:id
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

  # DELETE /user/:id
  def destroy
    unless User.destroy(@user.id)
      return render status: :unprocessable_entity,
                    json: Message::ERROR[:user_delete]
    end

    render status: :ok,
           json: Message::INFO[:user_delete]
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
