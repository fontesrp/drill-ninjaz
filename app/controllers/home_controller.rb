class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to drill_group_tabs_path(current_user)
    end
    @hide_navbar = true
  end
end
