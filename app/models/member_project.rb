# frozen_string_literal: true

class MemberProject < ApplicationRecord
  belongs_to :member
  belongs_to :project
end
