json.array! @members do |member|
  json.first_name member.first_name
  json.last_name member.last_name
end