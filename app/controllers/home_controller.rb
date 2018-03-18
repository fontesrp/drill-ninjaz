class HomeController < ApplicationController
  set_tab :home
  def index
    @hide_navbar = true
  end
end
