class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  # TODO: Remove when user authorization/authentication is set up
  # private
  #
  # def current_user
  #   @current_user ||= User.find 1
  # end
end
