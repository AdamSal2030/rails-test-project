json.array! @member do |member|
  json.team_id member.team_id
  json.id member.id
  json.first_name member.first_name
  json.last_name member.last_name
end