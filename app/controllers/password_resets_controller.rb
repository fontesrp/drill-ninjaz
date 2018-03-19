class PasswordResetsController < ApplicationController
before_action :get_user, only: [:edit, :update]
before_action :valid_user, only: [:edit, :update]
include SessionsHelper


  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:notice] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:alert] = "Email addresss not found. Sorry."
      render 'new'
    end
  end


  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, 'cant be empty')
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute( :reset_digest, nil)
      flash[:success] = 'Password has been reset!'
      redirect_to drill_group_tabs_path
    else
      render 'edit'

    end
  end


  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # Confirms a valid user
  def valid_user
    # unless (@user && @user.activated? && @user.authenticated?( :reset, params[:id]))
    unless (@user && @user.activated?)
      redirect_to root_path
    end
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end



end
