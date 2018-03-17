class QuestionsController < ApplicationController

  before_action :find_drill_group
  before_action :find_question, only: [:edit, :update, :destroy]

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
end
