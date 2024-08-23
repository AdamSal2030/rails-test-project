# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :member_projects, dependent: :nullify
  has_many :members, through: :member_projects
end
