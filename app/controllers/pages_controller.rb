# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    # If a user is logged in, the main navbar button ["home"] should take them to their Show page
    # otherwise take user to default Home page
    redirect_to articles_path if logged_in?
  end

  def about
    #  Comment to satisfy rubocop
  end
end
