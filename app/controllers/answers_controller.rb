class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!, except: :create

  # GET /answers
  # GET /answers.json
  def index
    @answers = Answer.all
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit
  end

  # POST /answers
  # POST /answers.json
  def create
    @answer = Answer.new(answer_params)

    respond_to do |format|
      if @answer.save
        format.html { redirect_to @answer, notice: 'Answer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @answer }
      else
        format.html { render action: 'new' }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  def new_create
    a_id = params[:alternative_id]
    cq_id = params[:choosen_question_id]
    created = DateTime.parse(params[:date])
    created_time = Time.zone.local(created.year, created.month, created.day, created.hour, created.minute, created.second)
    new_answer = Answer.new(alternative_id: a_id, choosen_question_id: cq_id, created_at: created_time)
    respond_to do 
      if new_answer.save
        return render json: {status: true} 
      else
        return render json: {status: false}
      end
    end
  end

  def save_delayed_answer
    result = Answer.save_answer_with_previous_check(params[:restaurant_id], params[:date], params[:choosen_question_id], params[:alternative_id] )
    respond_to do 
      if result
        return render json: {status: true} 
      else
        return render json: {status: false}
      end
    end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to @answer, notice: 'Answer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to answers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:choosen_question_id, :alternative_id)
    end
end
