class Restaurant < ActiveRecord::Base

	has_many :availabilities
	has_many :questions, through: :availabilities
	has_many :surveys

	def create_or_return_survey_for_today
		survey = Survey.where("restaurant_id = ? AND created_at >= ?", id, Time.zone.today.beginning_of_day)
		if survey.empty?
			survey = create_new_survey
		else
			survey = survey.first
		end
		survey
	end

	def create_new_survey
		new_survey = Survey.create(restaurant_id: id, name: "Encuesta creada: #{Time.zone.now}")
		SubCategory.all.each do |sc|
			available_questions = questions.where(sub_category_id: sc.id).shuffle
			unless available_questions.empty?
				new_survey.availabilities << Availability.where(restaurant_id: id, question_id: available_questions[0].id).first
				new_survey.availabilities << Availability.where(restaurant_id: id, question_id: available_questions[1].id).first
			end
		end
		new_survey
	end

end