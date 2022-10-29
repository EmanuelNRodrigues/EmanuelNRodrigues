# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include Message

  primary_abstract_class
end
