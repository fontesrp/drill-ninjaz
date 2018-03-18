class PasswordResetsController < ApplicationController


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
