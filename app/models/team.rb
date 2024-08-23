# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :members
  validates :name, presence: true
end
