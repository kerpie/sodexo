json.array!(@alternatives) do |alternative|
  json.extract! alternative, :id, :name, :question_id
  json.url alternative_url(alternative, format: :json)
end
