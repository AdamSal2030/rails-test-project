# frozen_string_literal: true

json.project do
  json.id @project.id
  json.name @project.name
end

json.member do
  json.id @member.id
  json.name @member.first_name
end

json.message 'Member added to project successfully'
