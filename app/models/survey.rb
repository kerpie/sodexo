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
		result = [status, hash, subs_to_return, time, survey]
	end
end