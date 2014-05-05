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
            format.xls do 
                data = render_to_string(template: "reports/result")
                send_data   data, 
                            filename: "#{@result[4].name}.xls",
                            type: 'application/vnd.ms-excel'
            end
            format.pdf do 
                render  pdf: @result[4].name,
                        disposition: "attachment",
                        template: "reports/_result.html.haml", 
                        locals: { result: @result, load_css: true}
=begin
                html = render_to_string(partial: "reports/result", formats: [:html], locals: {result: @result})
                kit = PDFKit.new(html)
                kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/print.css"
                send_data   kit.to_pdf,
                            filename: "Reporte.pdf",
                            content_type: "application/pdf"
=end
            end
        end
    end

    def range
        respond_to do |format|
            format.html
        end
    end

    def result_per_range
        @result = Survey.result_per_range(params[:restaurant_id], params[:start_date_for_report], params[:end_date_for_report])
        respond_to do |format|
            format.js
            format.json
            format.pdf do
                render  pdf: @result[4].name,
                        disposition: "attachment",
                        template: "reports/_result_per_range.html.haml", 
                        locals: { result: @result, load_css: true}
=begin
html = render_to_string(partial: "reports/result_per_range", formats: [:html], locals: {result: @result})
                kit = PDFKit.new(html)
                kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/print.css"
                send_data   kit.to_pdf,
                            filename: "Reporte.pdf",
                            content_type: "application/pdf"
=end

            end
        end
    end

    def report_per_month
        respond_to do |format|
            format.html
        end
    end

    def result_per_month
        @result = Survey.result_per_month(params[:restaurant_id], params[:month])
        respond_to do |format|
            format.js
            format.json
        end
    end

    def result_per_month_with_year
       @result = Survey.result_per_month_with_year(params[:restaurant_id], params[:month], params[:year])
        respond_to do |format|
            format.js
            format.json
            format.pdf do
                render  pdf: @result[5][:restaurant].name,
                        disposition: "attachment",
                        template: "reports/_result_per_month_with_year.html.haml", 
                        locals: { result: @result, load_css: true}
=begin                
                html = render_to_string(partial: "reports/result_per_month_with_year", formats: [:html], locals: {result: @result})
                kit = PDFKit.new(html)
                kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/print.css"
                send_data   kit.to_pdf,
                            filename: "Reporte.pdf",
                            content_type: "application/pdf"
=end
            end
        end 
    end

    def report_total
        respond_to do |format|
            format.html
        end
    end

    def result_total
        @result = Survey.result_total(params[:start_date], params[:end_date])
        respond_to do |format|
            format.js
            format.json
            format.pdf do
                render  pdf: "Reporte total del #{@result[1][:start]} al #{@result[1][:end]}",
                        disposition: "attachment",
                        template: "reports/_result_total.html.haml", 
                        locals: { result: @result, load_css: true}
=begin
                html = render_to_string(partial: "reports/result_total", formats: [:html], locals: {result: @result})
                kit = PDFKit.new(html)
                kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/print.css"
                send_data   kit.to_pdf,
                            filename: "Reporte.pdf",
                            content_type: "application/pdf"
=end

            end
        end
    end

    def report_detailed_by_service
        respond_to do |format|
            format.html
        end
    end

    def result_detailed_by_service
        @result = Survey.detailed_result(params[:restaurant_id], params[:start_date_for_report], params[:end_date_for_report])
        respond_to do |format|
            format.js
            format.pdf do
                render  pdf: "Reporte detallado",
                        disposition: "attachment",
                        template: "reports/_result_detailed_by_service.html.haml", 
                        locals: { result: @result, load_css: true}
=begin 
                html = render_to_string(partial: "reports/result_detailed_by_service", formats: [:html], locals: {result: @result})
                kit = PDFKit.new(html)
                kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/print.css"
                send_data   kit.to_pdf,
                            filename: "Reporte.pdf",
                            content_type: "application/pdf"
=end
            end
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

end
