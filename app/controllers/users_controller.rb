class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def index
  end

  def create
    @user = User.new user_params
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      redirect_to sign_up_thanks_path
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      render :new
    end
  end

  def show
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]

    if @user.update user_params
      flash[:notice] = 'Successfully updated!'
      redirect_to drill_group_tabs_path(@user)
    else
      flash[:alert] = 'Cannot update information'
      redirect_to user_path(@user)
    end
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
