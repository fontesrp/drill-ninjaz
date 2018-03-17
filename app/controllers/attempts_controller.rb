class AttemptsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question [:destroy]
  before_action :find_drill_group [:destroy]

  def create
    @drill_group = Drill_group.find params[:question_id]
    @question = Question.find params[:question_id]
    attempt = Attempt.new user: current_user, question: question
    attempt.save
  end

  def index
    @attempts = current_user.current_attempts
  end

  def show

  end

  def destroy
    @attempt = Attempt.find params[:id]
    @attempt.destroy
  end

  private
  def find_question
    @question = Question.find params[:question_id]
  end
  def find_drill_group
    @drill_group = Drill_group.find params[:drill_group_id]
  end
end
