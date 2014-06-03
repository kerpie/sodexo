class Answer < ActiveRecord::Base

	belongs_to :choosen_question
	belongs_to :alternatives

	def self.save_answer_with_previous_check(restaurant_id, date, choosen_question_id, alternative_id)
		restaurant = Restaurant.find(restaurant_id)

		tmp_date = DateTime.parse(date)
		created_time = Time.zone.local(tmp_date.year, tmp_date.month, tmp_date.day, tmp_date.hour, tmp_date.minute, tmp_date.second)

		last_known_choosen_question = ChoosenQuestion.find(choosen_question_id)

		survey = restaurant.surveys.where("created_at >= ? and created_at <= ?", created_time.beginning_of_day, created_time.end_of_day).first

		if survey.nil?
			survey = Survey.create(restaurant_id: restaurant.id, name: "Encuesta creada para #{restaurant.name} en #{created_time}", created_at: created_time)
			SubCategory.all.each do |sc|
				available_questions = restaurant.questions.where(sub_category_id: sc.id).shuffle
				unless available_questions.empty?
					available_questions.each do |aq|
						choosen_question = ChoosenQuestion.new
						choosen_question.survey_id = survey.id 
						choosen_question.availability_id = Availability.where(restaurant_id: restaurant.id, question_id: aq.id).first.id 
						choosen_question.created_at = created_time
						choosen_question.save
					end
				end
			end
		end

		new_cq = nil
		survey.choosen_questions.each do |cq|
			if cq.availability.question == last_known_choosen_question.availability.question 
				new_cq = cq 
				break
			end
		end

		status = false
		unless new_cq.nil?
			answer = Answer.new
			answer.choosen_question_id = new_cq.id
			answer.alternative_id = alternative_id
			answer.created_at = created_time
			if answer.save
				status = true
			else
				status = false
			end
		end

		status
	end

end