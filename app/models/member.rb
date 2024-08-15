class Member < ApplicationRecord
  belongs_to :team
  has_many :member_projects
  has_many :projects, through: :member_projects
  validates :first_name, :last_name, presence:true
end
