class PasswordResetsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:alert] = "Email addresss not found. Sorry."
      render 'new'
    end
  end



  def edit
    @user = User.find params[:email]
  end

  def update
    @user =  User.find params[:email]
    if @user&.authenticate(@user.password)

      if @user.update(password: password_params[:password],
      password_confirmation: password_params[:password_confirmation])

        flash[:notice] = "Password has been reset"
        redirect_to root_path
      else
        flash[:alert] = "Passwords do not match - try again"
        render :edit
      end
    end
  end



  private
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
