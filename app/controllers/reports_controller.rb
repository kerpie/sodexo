class ReportsController < ApplicationController

    def index
        @restaurants = Restaurant.all
    end

    def result
        @result = Survey.survey_result_with_date(params[:restaurant_id_for_survey], params[:date_for_survey])
        @id = params[:restaurant_id_for_survey]
        @date = params[:date_for_survey]
        respond_to do |format|
            format.html
            format.js
            format.json
            format.xls {
                headers["Content-Disposition"] = "attachment; filename=\"#{@result[4].name}.xls\"",
                headers["Content-Type"] = "application/vnd.ms-excel"
            }
        end
    end

    def check_survey_availability
        restaurant_id = params[:restaurant_id_for_survey]
        time = Time.strptime(params[:date_for_survey], '%m/%d/%Y')
        survey = Survey.where("restaurant_id = ? AND created_at >= ? AND created_at <= ?", restaurant_id, time.beginning_of_day, time.end_of_day).first
        if survey.nil?
            return render json: {status: false}
        else
            return render json: {status: true}
        end
    end

    def result_per_month
        @result = Survey.result_per_month(params[:restaurant_id], params[:month])
        respond_to do |format|
            format.json
        end
    end
end
