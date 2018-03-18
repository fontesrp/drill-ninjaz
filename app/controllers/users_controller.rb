class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def index
  end

  def create
    @user = User.new user_params
    if @user.save
      session[:user_id] = @user.id
      redirect_to sign_up_thanks_path
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      render :new
    end
  end

  def show
    @user. User.find params[:id]
  end

  def drill_group_tabs
    @user = current_user
    @all_drill_groups = DrillGroup.all
    @my_drill_groups = @user&.drill_group_attempts&.uniq
  end

def forgot_password

end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

end
