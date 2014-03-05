json.questions @survey.choosen_questions do |json, question|
	json.title question.availability.question.title
	json.total_count question.answers.count
	json.yes question.answers.where(alternative_id: question.availability.question.alternatives.first.id).count
end
