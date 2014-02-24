require 'test_helper'

class ChoosenQuestionsControllerTest < ActionController::TestCase
  setup do
    @choosen_question = choosen_questions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:choosen_questions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create choosen_question" do
    assert_difference('ChoosenQuestion.count') do
      post :create, choosen_question: { availability_id: @choosen_question.availability_id, survey_id: @choosen_question.survey_id }
    end

    assert_redirected_to choosen_question_path(assigns(:choosen_question))
  end

  test "should show choosen_question" do
    get :show, id: @choosen_question
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @choosen_question
    assert_response :success
  end

  test "should update choosen_question" do
    patch :update, id: @choosen_question, choosen_question: { availability_id: @choosen_question.availability_id, survey_id: @choosen_question.survey_id }
    assert_redirected_to choosen_question_path(assigns(:choosen_question))
  end

  test "should destroy choosen_question" do
    assert_difference('ChoosenQuestion.count', -1) do
      delete :destroy, id: @choosen_question
    end

    assert_redirected_to choosen_questions_path
  end
end
