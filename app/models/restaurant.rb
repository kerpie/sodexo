class Restaurant < ActiveRecord::Base

	has_many :availabilities
	has_many :questions, through: :availabilities
	has_many :surveys

	has_many :authorizations
	has_many :users, through: :authorizations

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
		new_survey = Survey.create(restaurant_id: id, name: "Encuesta creada para #{name} en #{Time.zone.now}", created_at: Time.zone.now)
		SubCategory.all.each do |sc|
			available_questions = questions.where(sub_category_id: sc.id).shuffle
			unless available_questions.empty?
				available_questions.each do |aq|
					new_survey.availabilities << Availability.where(restaurant_id: id, question_id: aq.id).first
				end
			end
		end
		new_survey
	end

	def survey_result_of_today
		survey = Survey.where("restaurant_id = ? AND created_at >= ?", id, Time.zone.today.beginning_of_day)
		if survey.empty?
			return nil
		else
			survey = survey.first
			hash = {}
			SubCategory.all.each do |sub_cat|
				hash[sub_cat.name] = []
			end
			tmp_array = []
			survey.choosen_questions.each do |cq|
				hash[cq.availability.question.sub_category.name] << cq
			end
			hash
		end

	end

	def add_to_proper_users
		types = [2,3,4]
		types.each do |type_id|
			UserType.find(type_id).users.each do |u|
				u.restaurants << Restaurant.find(id)
			end
		end
	end

	def destroy_from_proper_users
		Authorization.where(restaurant_id: id).each do |r|
			r.destroy
		end
	end
end
