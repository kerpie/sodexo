class ChoosenQuestionsController < ApplicationController
  before_action :set_choosen_question, only: [:show, :edit, :update, :destroy]

  # GET /choosen_questions
  # GET /choosen_questions.json
  def index
    @choosen_questions = ChoosenQuestion.all
  end

  # GET /choosen_questions/1
  # GET /choosen_questions/1.json
  def show
  end

  # GET /choosen_questions/new
  def new
    @choosen_question = ChoosenQuestion.new
  end

  # GET /choosen_questions/1/edit
  def edit
  end

  # POST /choosen_questions
  # POST /choosen_questions.json
  def create
    @choosen_question = ChoosenQuestion.new(choosen_question_params)

    respond_to do |format|
      if @choosen_question.save
        format.html { redirect_to @choosen_question, notice: 'Choosen question was successfully created.' }
        format.json { render action: 'show', status: :created, location: @choosen_question }
      else
        format.html { render action: 'new' }
        format.json { render json: @choosen_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /choosen_questions/1
  # PATCH/PUT /choosen_questions/1.json
  def update
    respond_to do |format|
      if @choosen_question.update(choosen_question_params)
        format.html { redirect_to @choosen_question, notice: 'Choosen question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @choosen_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /choosen_questions/1
  # DELETE /choosen_questions/1.json
  def destroy
    @choosen_question.destroy
    respond_to do |format|
      format.html { redirect_to choosen_questions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_choosen_question
      @choosen_question = ChoosenQuestion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def choosen_question_params
      params.require(:choosen_question).permit(:availability_id, :survey_id)
    end
end
