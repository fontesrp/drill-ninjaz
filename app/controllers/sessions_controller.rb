class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Thank you for signing in! Get drilling!"
      redirect_to drill_group_tabs_path(user)
    else
      flash[:alert] = 'Wrong email or password'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, alert: "Logged out!"
  end


private

  def session_params
    params.require(:session).permit(:email, :password)
  end

end
