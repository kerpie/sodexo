json.questions @survey.choosen_questions do |json, question|
	json.choosen_question_id question.id
	json.start_time question.availability.question.sub_category.start_time.in_time_zone
	json.end_time question.availability.question.sub_category.end_time.in_time_zone
	json.title question.availability.question.title
	json.alternatives question.availability.question.alternatives do |json, alternative|
		json.extract! alternative, :id, :name
	end
end