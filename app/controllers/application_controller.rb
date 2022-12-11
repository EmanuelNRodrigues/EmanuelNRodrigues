# frozen_string_literal: true

class ApplicationController < ActionController::API
  def user_id
    params.require(:user_id)
  end
end
