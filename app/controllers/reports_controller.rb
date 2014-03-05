class ReportsController < ApplicationController
  def index
  	@restaurants = Restaurant.all
  end

  def result
  	@result = Survey.survey_result_with_date(params[:restaurant_id_for_survey], params[:date_for_survey])
  	respond_to do |format|
  		format.html
  		format.js
  		format.json
  	end
  end
end