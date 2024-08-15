class Project < ApplicationRecord
  has_many :member_projects
  has_many :members, through: :member_projects
end
