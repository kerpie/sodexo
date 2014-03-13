class Survey < ActiveRecord::Base

	belongs_to :restaurant
	has_many :choosen_questions, dependent: :destroy
	has_many :availabilities, through: :choosen_questions

	def self.survey_result_with_date(restaurant_id, date)
		hash = {}
		subs = SubCategory.first(3)
		more_subs = SubCategory.last(2)
		time = Time.strptime(date, '%m/%d/%Y')
		survey = where("restaurant_id = ? AND created_at >= ? AND created_at <= ?", restaurant_id, time.beginning_of_day, time.end_of_day).first
		status = false
		subs_to_return = []
		unless survey.nil?
			status = true
			subs.each do |sub|
				array = []
				survey.choosen_questions.each do |cq|
					if cq.availability.question.sub_category == sub
						array << cq
					end
				end
				more_subs.each do |another_sub|
					survey.choosen_questions.each do |cq|
						if cq.availability.question.sub_category == another_sub
							array << cq
						end
					end
				end
				unless array.empty?
					hash[sub] = array
					subs_to_return << sub
				end
			end
		end

		# status: if there is a survey is found
		# hash: hash[sub_category]: choosen_questions
		# subs_to_return: First 3 sub_categories
		# time: date to look for a survey
		# survey: survey per se
		result = [status, hash, subs_to_return, time, survey]
	end

	def self.result_per_month(restaurant_id, month)
		restaurant = Restaurant.find(restaurant_id)
		time = Time.new(Time.zone.now.year, month, 1)

		surveys = restaurant.surveys.where("created_at >= ? AND created_at <= ?", time.beginning_of_month, time.end_of_month)
		hash_days = {}
		hash_data = {}
		total = surveys.count
		status = false
		
		if surveys.count > 0
			status = true 
		end

		surveys.each.with_index(0) do |survey, index|
			hash_days[index] = survey.created_at.day
			yes = 0
			no = 0
			survey.choosen_questions.each do |cq|
				yes += cq.answers.where(alternative_id: cq.availability.question.alternatives.first).count
				no += cq.answers.count - cq.answers.where(alternative_id: cq.availability.question.alternatives.first).count
			end
			hash_data[survey.created_at.day.to_s] = {yes: yes, no: no}
		end
		# status: if there are surveys in the indicated month
		# total: total of surveys
		# hash_days: days index
		# hash_data: survey result per day
		result = [status, total, hash_days, hash_data]
	end
end