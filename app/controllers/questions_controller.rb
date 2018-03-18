class QuestionsController < ApplicationController

  before_action :find_drill_group
  before_action :find_question, only: [:edit, :update, :destroy, :show, :answer, :next]
  before_action :find_next_question, only: [:show, :answer, :next]

  def create

    @question = Question.new question_params
    @question.drill_group = @drill_group

    if @question.save
      redirect_to @drill_group
    else
      render 'drill_group/show'
    end
  end

  def edit
  end

  def update
    if @question.update question_params
      redirect_to @drill_group
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to @drill_group
  end

  def show
    @correct_answer = nil
  end

  def start_group

    session[:correct_answers] = 0

    first_question = @drill_group.questions.order(:id).first

    # Search for Attempt added as favorite.
    attempt = Attempt.find_by user: current_user, drill_group: @drill_group, current_question_id: nil, score: nil

    if attempt.present?
      attempt.update score: 0, current_question: first_question
    else
      Attempt.create user: current_user, drill_group: @drill_group, score: 0, current_question: first_question
    end

    redirect_to drill_group_question_path(@drill_group, first_question)
  end

  def answer

    @user_answer = params.require :answer

    @correct_answer = is_correct? @user_answer

    if @correct_answer
      session[:correct_answers] ||= 0
      session[:correct_answers] += 1
      set_user_score(session[:correct_answers])
    end

    render :show
  end

  def next

    current_attempt.update current_question: @next_question

    redirect_to drill_group_question_path(@drill_group, @next_question)
  end

  def finish_group
    session[:correct_answers] = 0
    redirect_to root_path
  end

  private

  def question_params
    params.require(:question).permit :description, solutions_attributes: [:id, :answer, :_destroy]
  end

  def find_drill_group
    @drill_group = DrillGroup.find params.require :drill_group_id
  end

  def find_question
    @question = Question.find params.require :id
  end

  def is_correct?(user_answer)

    @question.solutions.each do |solution|
      if solution.answer == user_answer
        return true
      end
    end

    false
  end

  def find_next_question
    @next_question = @drill_group.questions.where("id > :id", id: @question.id).order(:id).first
  end

  def current_attempt
    Attempt.order(updated_at: :DESC).find_by user: current_user, drill_group: @drill_group
  end

  def set_user_score(correct_answers)

    question_qtt = @drill_group.questions.count

    current_attempt.update score: correct_answers / question_qtt
  end
end
