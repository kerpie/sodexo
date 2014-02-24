json.array!(@availabilities) do |availability|
  json.extract! availability, :id, :question_id, :restaurant_id
  json.url availability_url(availability, format: :json)
end
