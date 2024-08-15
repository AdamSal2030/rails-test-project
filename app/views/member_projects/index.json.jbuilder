json.project do
  json.id @project.id
  json.name @project.name
end

json.members @members do |member|
  json.id member.id
  json.first_name member.first_name
  json.last_name member.last_name
end