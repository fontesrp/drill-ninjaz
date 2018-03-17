class AttemptsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_drill_group, except: [:destroy]

  def create
    @drill_group = DrillGroup.find params[:drill_group_id]
    attempt = Attempt.new user: current_user, drill_group: @drill_group
    if attempt.save
      redirect_to attempts_path
    else
      redirect_to root_path
    end
  end

  def index
    @attempts = current_user.drill_group_attempts
  end

  def show
  end

  def destroy
    @attempt = Attempt.find params[:id]
    @attempt.destroy
  end

  private
  def find_drill_group
    @drill_group = DrillGroup.find params[:drill_group_id]
  end
end
