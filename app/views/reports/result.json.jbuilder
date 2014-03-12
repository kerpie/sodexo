json.status @result[0]
if @result[0]
	json.sub_categories @result[2] do |sub_category|
		json.extract! sub_category, :name
	end
	@result[2].each do |sub_category|
		json.set! sub_category.name do
			json.array! @result[1][sub_category].each do |cq|
				json.question_name cq.availability.question.title
				json.total total=cq.answers.where("created_at >= ? AND created_at <= ?", sub_category.start_time.in_time_zone.change(year: @result[3].year, month: @result[3].month, day: @result[3].day), sub_category.end_time.in_time_zone.change(year: @result[3].year, month: @result[3].month, day: @result[3].day)).count
				json.yes yes=cq.answers.where("alternative_id = ? AND created_at >= ? AND created_at <= ?", cq.availability.question.alternatives.first.id, sub_category.start_time.in_time_zone.change(year: @result[3].year, month: @result[3].month, day: @result[3].day), sub_category.end_time.in_time_zone.change(year: @result[3].year, month: @result[3].month, day: @result[3].day)).count
				json.no no=cq.answers.where("alternative_id = ? AND created_at >= ? AND created_at <= ?", cq.availability.question.alternatives.last.id, sub_category.start_time.in_time_zone.change(year: @result[3].year, month: @result[3].month, day: @result[3].day), sub_category.end_time.in_time_zone.change(year: @result[3].year, month: @result[3].month, day: @result[3].day)).count
				if total > 0
					json.yes_percentage (yes*100/total).to_s + "%"
					json.no_percentage (no*100/total).to_s + "%"
				else
					json.yes_percentage 0
					json.no_percentage 0
				end
			end
		end
	end
else
	json.message "No existe una encuesta creada para el local en la fecha indicada"
end