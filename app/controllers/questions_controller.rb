require 'rspec/expectations'

class QuestionsController < ApplicationController

  include RSpec::Matchers

  before_action :find_drill_group
  before_action :find_question, only: [:edit, :update, :destroy, :show, :answer, :next]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  before_action :find_next_question, only: [:show, :answer, :next]

  def create

    @question = Question.new question_params
    @question.drill_group = @drill_group

    if @question.drill_group.user.is_admin?
      if @question.save
        redirect_to @drill_group
      else
        flash.now[:alert] = @question.errors.full_messages.join(', ')
        render 'drill_groups/show'
      end
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

    current_question = current_attempt.current_question

    if @question != current_question
      redirect_to drill_group_question_next_path(@drill_group, current_question)
    end

    @correct_answer = nil
    @user_answer = ''
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

    @user_answer = params[:answer]

    @correct_answer = is_correct? @user_answer

    if @correct_answer
      session[:correct_answers] ||= 0
      qtt = session[:correct_answers].to_i + 1
      set_user_score(qtt)
      session[:correct_answers] = qtt
    end

    render :show
  end

  def next
    current_attempt.update current_question: @next_question

    redirect_to drill_group_question_path(@drill_group, @next_question)
  end

  def finish_group

    session[:correct_answers] = 0

    score = current_attempt.score
    if score < 0.5
      flash[:alert] = "Sorry, you suck! You completed the \"#{@drill_group.name}\" drill group with a score of #{(score * 100).to_i}%"
    else
      flash[:notice] = "Congratulations! You completed the \"#{@drill_group.name}\" drill group with a score of #{(score * 100).to_i}%"
    end

    redirect_to drill_group_tabs_path(current_user)
  end

  private

  def question_params
    params.require(:question).permit :description, :language, solutions_attributes: [:id, :answer, :input, :output, :_destroy]
  end

  def authorize_user!
    unless can?(:crud, @question)
      flash[:alert] = 'Access Denied!'
      redirect_to drill_group_path(@drill_group)
    end
  end

  def find_drill_group
    @drill_group = DrillGroup.find params.require :drill_group_id
  end

  def find_question
    @question = Question.find params.require :id
  end

  def escape_code(code)

    escaped = code.strip;

    # remove trailing spaces and identation
    escaped.gsub!(/([ \t]+(?=([\r\n]|$)))|(^[ \t]+)/, '')

    # remove empty lines and carriage returns
    escaped.gsub!(/[\r\n]+/, "\n")

    # compress spaces
    escaped.gsub!(/[ \t]+/, ' ')

    escaped
  end

  def is_correct_rspec?(user_answer)

    answer = escape_code user_answer

    valid_format = /^def \w+(\(.*\))?\n(.|\n)*\nend$/

    unless valid_format =~ answer
      @error = 'invalid format, please wrap your code in a method'
      return false
    end

    begin
      user_method = eval(answer)
    rescue Exception => exc
      @error = "sintax error: #{exc.message}"
      return false
    end

    correct = false

    @question.solutions.each do |solution|
      begin
        expect(send(user_method, solution.input).to_s).to eq(solution.output)
      rescue Exception => exc
        @error =  "input: \"#{solution.input}\"#{exc.message}"
        return false
      end
    end

    true
  end

  def is_correct_regexp?(user_answer)

    answer = escape_code user_answer

    @question.solutions.each do |solution|

      sol = escape_code solution.answer

      sol_rgx = Regexp.new "^#{Regexp.escape sol}$", Regexp::IGNORECASE

      if sol_rgx =~ answer
        return true
      end
    end

    false
  end

  def is_correct?(user_answer)
    if @question.language == 'ruby'
      is_correct_rspec? user_answer
    else
      is_correct_regexp? user_answer
    end
  end

  def find_next_question
    @next_question = @drill_group.questions.where("id > :id", id: @question.id).order(:id).first
  end

  def current_attempt
    Attempt.order(updated_at: :DESC).find_by user: current_user, drill_group: @drill_group
  end

  def set_user_score(correct_answers)

    question_qtt = @drill_group.questions.count

    score = correct_answers.to_f / question_qtt

    current_attempt.update score: score
  end
end
