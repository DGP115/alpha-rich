# frozen_string_literal: true

# Methods here are common to all app-specific controllers
class ApplicationController < ActionController::Base
  # This statement means the helper methods can also be used in Views
  helper_method :current_user, :logged_in?

  def current_user
    # If @current_user has already been defined, return it; else, and only if
    # session[:current_user_id] is not nil, create it
    @current_user ||= User.find(session[:current_user_id]) if session[:current_user_id]
  end

  def logged_in?
    if current_user
      true
    else
      false
    end
  end

  # rubocop prefers the style used below:
  # def require_user
  #   if !loggin_in?
  #     flash[:alert] = 'You must be logged in to perform that action'
  #     redirect_to login_path
  #   end
  # end
  #  -------------- These methods protect the app from users who know enough to type
  #                  valid routes into the browser address bar
  def require_user
    return if logged_in?
    flash[:alert] = 'You must be logged in to perform that action'
    redirect_to login_path
  end
end
