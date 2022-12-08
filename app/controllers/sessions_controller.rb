# frozen_string_literal: true

# This is the controller for the articles resource
class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email_address: params[:session][:email_address].downcase)

    #  Not my style by style guide prefers the "&." operator versus if user && user.authenticate...
    if user&.authenticate(params[:session][:password])
      # Record id of successfully logged-in user in session object (physically stored by Rails
      # in a cookie)
      session[:current_user_id] = user.id
      flash[:info] = 'Login was successful.'
      redirect_to user
    else
      flash.now[:warning] = 'Login was not successful.  Please try again.'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    session[:current_user_id] = nil
    flash[:info] = 'You are now logged out'
    redirect_to root_path
  end
end
