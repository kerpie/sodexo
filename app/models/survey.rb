class Survey < ActiveRecord::Base

	belongs_to :restaurant
	has_many :choosen_questions, dependent: :destroy
	has_many :availabilities, through: :choosen_questions

	def self.survey_result_with_date(restaurant_id, date)
		hash = {}
		subs = SubCategory.first(3)
		more_subs = SubCategory.last(2)
		restaurant = Restaurant.find(restaurant_id)
		time = Time.strptime(date, '%d/%m/%Y')
		survey = where("restaurant_id = ? AND created_at >= ? AND created_at <= ?", restaurant_id, time.beginning_of_day, time.end_of_day).first
		status = false

		extra_data = {}
		extra_data[:restaurant_name] = restaurant.name
		extra_data[:restaurant_id] = restaurant.id
		extra_data[:date] = date

		unless survey.nil?
			status = true
			subs.each do |sub|
				tmp_hash = {}
				total_yes = 0
				total_no = 0
				array = []
				survey.choosen_questions.each do |cq|
					unless cq.availability.nil?
						if cq.availability.question.sub_category == sub
							array << cq
						end
					end
				end
				more_subs.each do |another_sub|
					survey.choosen_questions.each do |cq|
						unless cq.availability.nil?
							if cq.availability.question.sub_category == another_sub
								array << cq
							end
						end
					end
				end
				new_array = []
				unless array.empty?
					array.each do |question|
						valid_answers = question.answers.where("created_at >= ? and created_at <= ?", sub.start_time.in_time_zone.change(year: time.year, month: time.month, day: time.day), sub.end_time.in_time_zone.change(year: time.year, month: time.month, day: time.day))
						positive_answers = valid_answers.where(alternative_id: question.availability.question.alternatives.first)
						total_yes += positive_answers.count
						total_no += (valid_answers.count - positive_answers.count)
						new_array << {
							question: question.availability.question.title,
							yes: positive_answers.count,
							no: valid_answers.count - positive_answers.count
						}
					end
					tmp_hash[:total_yes] = total_yes
					tmp_hash[:total_no] = total_no
					tmp_hash[:questions] = new_array
				end
				hash[sub.name.strip] = tmp_hash
			end
		end

		[status, hash, extra_data]
	end

	def self.result_per_range(restaurant_id, start_date, end_date)
		hash = {}
		restaurant = Restaurant.find(restaurant_id)
		start_time = Time.strptime(start_date, "%d/%m/%Y")
		end_time = Time.strptime(end_date, "%d/%m/%Y")
		surveys = restaurant.surveys.where("created_at >= ? AND created_at <= ?", start_time.beginning_of_day, end_time.end_of_day).order(:created_at)
		status = surveys.empty? ? false : true

		subs = SubCategory.first(3)
		more_subs = SubCategory.last(2)

		extra_data = {}
		extra_data[:restaurant_name] = restaurant.name
		extra_data[:restaurant_id] = restaurant.id
		extra_data[:start_date] = start_date
		extra_data[:end_date] = end_date

		if status 
			subs.each do |sub|
				total_yes = 0
				total_no = 0
				final_hash = {}

				#Obtain questions from subcategories 
				questions_to_look = restaurant.questions.where(sub_category_id: sub.id)
				more_subs.each do |another_sub|
					more_questions = restaurant.questions.where(sub_category_id: another_sub.id)
					unless more_questions.empty?
						more_questions.each do |mq| 
							questions_to_look << mq
						end
					end
				end

				array_with_results = []
				questions_to_look.each do |ql|
					array_with_matched_question = []
					tmp_hash = {}
					surveys.each do |survey|
						survey.choosen_questions.each do |cq|
							unless cq.availability.nil?
								array_with_matched_question << cq if cq.availability.question == ql
							end
						end
					end

					local_yes = 0
					local_no = 0

					array_with_matched_question.each do |question|
						valid_answers = question.answers.where(
							"created_at >= ? and created_at <= ?", 
							sub.start_time.in_time_zone.change(year: question.created_at.year, month: question.created_at.month, day: question.created_at.day),
							sub.end_time.in_time_zone.change(year: question.created_at.year, month: question.created_at.month, day: question.created_at.day)
						)
						positive_answers = valid_answers.where(alternative_id: question.availability.question.alternatives.first)
						local_yes += positive_answers.count
						local_no += valid_answers.count - positive_answers.count
					end

					tmp_hash[:question] = ql.title
					tmp_hash[:yes] = local_yes
					tmp_hash[:no] = local_no

					total_yes += local_yes
					total_no += local_no

					array_with_results << tmp_hash
				end

				final_hash[:total_yes] = total_yes
				final_hash[:total_no] = total_no
				final_hash[:questions] = array_with_results

				hash[sub.name.strip] = final_hash
			end
		end

		[status, hash, extra_data]
	end

	def self.result_per_month(restaurant_id, month)
		restaurant = Restaurant.find(restaurant_id)
		time = Time.new(Time.zone.now.year, month, 1)

		surveys = restaurant.surveys.where("created_at >= ? AND created_at <= ?", time.beginning_of_month, time.end_of_month).order(:created_at)
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

	def self.result_per_month_with_year(restaurants_ids, months, year)
		
		#Final data to return
		hash = {}

		#Restaurants and months indexes
		restaurants = []
		times = []

		only_ids = []

		restaurants_ids.each do |id|
			r = Restaurant.find(id)
			restaurants << r unless r.nil?
			only_ids << r.id unless r.nil?
		end

		months_in_numbers = []
		months.each do |month|
			times << Time.zone.local(year, month, 1)
			months_in_numbers << month.to_i
		end

		restaurants_names = []
		restaurants.each do |r|
			restaurants_names << r.name
		end

		hash[:months] = months_in_numbers
		hash[:restaurants] = restaurants_names

		subs = SubCategory.first(3)
		more_subs = SubCategory.last(2)
		
		restaurants.each do |restaurant|

			monthly_data = {}

			times.each do |time|

				total_yes = 0
				total_no = 0

				surveys_per_restaurant = restaurant.surveys.where("created_at >= ? and created_at <= ?", time.beginning_of_month, time.end_of_month).order(:created_at)
				days = []
				values_per_day = {}

				surveys_per_restaurant.each do |survey|
					days << survey.created_at.day

					total_yes_per_survey = 0
					total_no_per_survey = 0

					subs.each do |sub|
						array = []
						survey.choosen_questions.each do |cq|
							unless cq.availability.nil?
								if cq.availability.question.sub_category == sub
									array << cq
								end
							end
						end
						more_subs.each do |another_sub|
							survey.choosen_questions.each do |cq|
								unless cq.availability.nil?
									if cq.availability.question.sub_category == another_sub
										array << cq
									end
								end
							end
						end
						unless array.empty?
							array.each do |choosen_question|
								tmp = {}
								valid_answers = choosen_question.answers.where("created_at >= ? and created_at <= ?", sub.start_time.in_time_zone.change(year: year, month: time.month, day: choosen_question.created_at.day),sub.end_time.in_time_zone.change(year: year, month: time.month, day: choosen_question.created_at.day))
								positive_answers = valid_answers.where(alternative_id: choosen_question.availability.question.alternatives.first.id)

								total_yes_per_survey += positive_answers.count 
								total_no_per_survey += (valid_answers.count - positive_answers.count)
							end
						end
					end
					total_yes += total_yes_per_survey
					total_no += total_no_per_survey
					values_per_day[survey.created_at.day] = {yes: total_yes_per_survey, no: total_no_per_survey}
				end

				monthly_data[time.month] = {total_yes: total_yes, total_no: total_no, days: days, values_per_day: values_per_day}
			end
			hash[:year] = year
			hash[restaurant.name] = monthly_data
		end

		restaurants.each do |restaurant|

			total_yes = 0
			total_no = 0

			months_in_numbers.each do |month|
				unless hash[restaurant.name].nil? && hash[restaurant.name][month].nil?
					total_yes += (hash[restaurant.name][month][:total_yes].nil? ? 0 : hash[restaurant.name][month][:total_yes])
					total_no += (hash[restaurant.name][month][:total_no].nil? ? 0 : hash[restaurant.name][month][:total_no])
				end
			end

			hash[restaurant.name][:total_yes] = total_yes
			hash[restaurant.name][:total_no] = total_no
		end

		summary_result = {}
		months_in_numbers.each do |month|
			month_yes = 0
			month_no = 0
			restaurants.each do |restaurant|
				month_yes += hash[restaurant.name][month][:total_yes]
				month_no += hash[restaurant.name][month][:total_no]
			end

			summary_result[month] = {yes: month_yes, no: month_no}
		end

		hash[:restaurant_ids] = only_ids
		hash[:summary] = summary_result

		hash
	end

	def self.result_total(start_date, end_date)
		start_time = Time.strptime(start_date, "%d/%m/%Y")
		end_time = Time.strptime(end_date, "%d/%m/%Y")

		subs = SubCategory.first(3)
		more_subs = SubCategory.last(2)

		surveys = Survey.where("created_at >= ? and created_at <= ?", start_time.in_time_zone.beginning_of_day, end_time.in_time_zone.end_of_day)
		logger.debug "surveys quantity: #{surveys.count}"

		response = []
		
		total_yes = 0
		total_no = 0

		response = {}
		
		subs.each do |sub|
			#Total per subcategory
			questions_per_sub_category = []
			
			sub.questions.each do |question|
				questions_per_sub_category << question
			end

			more_subs.each do |more_sub| 
				more_sub.questions.each do |another_question|
					questions_per_sub_category << another_question
				end
			end

			total_yes_per_sub_category = 0
			total_no_per_sub_category = 0
			sub_category_result = []

			questions_per_sub_category.each do |question|
				matching_choosen_questions = []

				surveys.each do |survey|
					survey.choosen_questions.each do |cq|
						unless cq.availability.nil?
							if cq.availability.question == question
								matching_choosen_questions << cq 
								break
							end
						end
					end
				end

				total_yes_per_question = 0
				total_no_per_question = 0

				matching_choosen_questions.each do |matched_choosen_question|
					valid_answers = matched_choosen_question.answers.where("created_at >= ? and created_at <= ?", sub.start_time.in_time_zone.change(year: matched_choosen_question.created_at.year, month: matched_choosen_question.created_at.month, day: matched_choosen_question.created_at.day), sub.end_time.in_time_zone.change(year: matched_choosen_question.created_at.year, month: matched_choosen_question.created_at.month, day: matched_choosen_question.created_at.day))
					positive_answers = valid_answers.where(alternative_id: matched_choosen_question.availability.question.alternatives.first)
					
					valid_answers_count = valid_answers.count
					positive_answers_count = positive_answers.count

					total_yes_per_question += positive_answers_count
					total_no_per_question += (valid_answers_count - positive_answers_count)

					total_yes_per_sub_category += positive_answers_count
					total_no_per_sub_category += (valid_answers_count - positive_answers_count)
				end

				sub_category_result << {question: question.title, yes: total_yes_per_question, no: total_no_per_question}
			end

			response[sub.name.strip] = {questions: sub_category_result, total_yes: total_yes_per_sub_category, total_no: total_no_per_sub_category}
		end
		[response,{start_date: start_date, end_date: end_date}]
	end

	def self.detailed_result(restaurant_id, start_date, end_date)
		restaurant = Restaurant.find(restaurant_id)
		start_time = Time.strptime(start_date, "%d/%m/%Y")
		end_time = Time.strptime(end_date, "%d/%m/%Y")

		surveys = restaurant.surveys.where("created_at >= ? AND created_at <= ?", start_time.beginning_of_day, end_time.end_of_day).order(:created_at)
		total = 0
		hash = {}
		SubCategory.first(3).each do |sc|
			yes = 0
			no = 0
			surveys.each do |survey|
				tmp_start_time = Time.zone.local(
					start_time.year, 
					start_time.month, 
					start_time.day, 
					sc.start_time.in_time_zone.hour,
					sc.start_time.in_time_zone.min,
					sc.start_time.in_time_zone.sec
				)
				tmp_end_time = Time.zone.local(
					end_time.year, 
					end_time.month, 
					end_time.day, 
					sc.end_time.in_time_zone.hour,
					sc.end_time.in_time_zone.min,
					sc.end_time.in_time_zone.sec
				)
				survey.choosen_questions.each do |cq|
					yes += cq.answers.where("alternative_id = ? AND created_at >= ? AND created_at <= ?", cq.availability.question.alternatives.first, tmp_start_time, tmp_end_time).count
					no += cq.answers.where("alternative_id = ? AND created_at >= ? AND created_at <= ?", cq.availability.question.alternatives.last, tmp_start_time, tmp_end_time).count
				end
			end
			total = yes+no
			hash[sc] = {total: total, yes: yes, no: no}
		end
		[restaurant, hash, {restaurant: restaurant.id, start_date: start_date, end_date: end_date}]
	end

end
