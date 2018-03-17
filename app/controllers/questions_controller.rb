class QuestionsController < ApplicationController

  def create

    @drill_group = DrillGroup.find params.require :drill_group_id
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
  end

  def destroy
  end

  private

  def question_params
    params.require(:question).permit :description, solutions_attributes: [:id, :answer, :_destroy]
  end
end
