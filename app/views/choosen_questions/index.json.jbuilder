json.array!(@choosen_questions) do |choosen_question|
  json.extract! choosen_question, :id, :availability_id, :survey_id
  json.url choosen_question_url(choosen_question, format: :json)
end
