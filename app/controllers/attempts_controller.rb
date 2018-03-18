class AttemptsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_drill_group, except: [:add_to_drills]
  before_action :authorize_user!, only: [:destroy, :create]

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
    @user = @attempt.user
    attempts_array = Attempt.where user: @user, drill_group: @drill_group
    attempts_array.destroy_all

    redirect_to drill_group_tabs_path(@user)
  end

  def add_to_drills
    @drill_group = DrillGroup.find params[:drill_id]
    Attempt.create user: current_user, drill_group: @drill_group
    # @drill_group.attempts.create(user: current_user)
    redirect_to drill_group_tabs_path(current_user.id)
  end

  private
  def find_drill_group
    @attempt = Attempt.find params[:id]
    @drill_group = @attempt.drill_group
  end

  def authorize_user!

     unless can?(:crud, @attempt)
       flash[:alert] = "Access Denied"
       redirect_to root_path
     end
  end

end
