# frozen_string_literal: true

# This is the controller for the users resource
class UsersController < ApplicationController
  # before_action is a helper.  It is run first [limited to only statement] as a
  # means of DRYing code
  before_action :set_user, only: %i[show edit update destroy]
  # The below ensures that a user that is not logged in can't access user profiles
  # by entering routes directly in the browser address bar
  before_action :require_user, only: %i[edit update]
  # The below runs after "set_user" (above) so "require_same_user" can use object
  # "@user" knowing it has been instantiated [because it is instantiated
  # in "set_user"]
  before_action :require_same_user, only: %i[edit update destroy]

  def show
    # In preparation for the user show page, get a list of the articles authored by
    # the current user.  Note @articles, here, is an array, not an object
    @articles = @user.articles.paginate(page: params[:page], per_page: 5).order('created_at DESC')
  end

  def index
    # Utilizing the will_paginate gem to include pagination as this code was
    # @users = User.all, which could return many rows
    @users = User.paginate(page: params[:page], per_page: 5).order('username ASC')
  end

  def new
    # Create a new user object immediately upon entry of this method so that
    # a valid user object exists when the Show etc. pages are first entered.
    # Otherwise, the error trapping done there will fail
    @user = User.new
  end

  def edit; end

  def create
    # Instantiate a user object based on what is returned from the browser via params hash
    # Below is an example of some Rails security.  Rather than having Rails assign the username
    # etc. attributes directly:
    #   1. use the .require method to identify that it is the user resource we want
    #   2. .permit  method to specifically retrieve the attributes listed
    @user = User.new(whitelist_user_params)

    if @user.save

      # For convenience, perform a log-in for the newly signed up user
      session[:current_user_id] = @user.id

      # Generate a confirmation message for the user.
      flash[:success] = "Welcome #{@user.username}.  You have successfully signed up."

      # Now that the user is saved, we need to tell Rails what to do.
      # Convention would take the app user to the newly created user's Show page
      # Examination of Rails route for the Show action (See below) indicates:
      #  "Prefix" of "user" --> telling us the path to the user's show page is user_path
      #  "URI" --> telling us we need to provide the unique user id.
      #            We can do this by providing Rails the user object.  It "knows" to get the id
      #            from the object.
      #       --[ Route 6 ]------------
      #       Prefix            | user
      #       Verb              | GET
      #       URI               | /articles/:id(.:format)
      #       Controller#Action | articles#show
      redirect_to articles_path

    else

      # Error trapping
      # Re-render the "new" user page.
      # Because the save returned false, the error trapping on the "new" page
      # will display the errors
      render 'new', status: :unprocessable_entity

    end
  end

  def update
    if @user.update(whitelist_user_params)
      #
      # Generate a confirmation message for the user.
      flash[:notice] = 'User profile was updated successfully'

      # Now that the user is updated, we need to tell Rails what to do.
      # Convention would take the app user to the newly updated user's Show page
      # Examination of Rails route for the Show action (See below) indicates:
      #  "Prefix" of "????" --> telling us the path to the ????'s show page is user_path
      #  "URI" --> telling us we need to provide the unique user id.
      #            We can do this by providing Rails the user object.  It "knows" to get the id
      #            from the object.
      #       --[ Route 6 ]------------
      #       Prefix            | user
      #       Verb              | GET
      #       URI               | /????/:id(.:format)
      #       Controller#Action | ?????#show
      redirect_to user_path

    else

      # Error trapping
      # Re-render the "edit" user page.
      # Because the save returned false, the error trapping on the "edit" page
      # will display the errors
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    # 1.  Log user out IFF they are the account owner
    session[:current_user_id] = nil if @user == current_user
    # 2.  destroy user and all articles authored by user.  Articles destroy happens due to
    #     "has_many :articles, dependent: :destroy" in user.rb.  Amazing
    @user.destroy
    flash[:notice] = 'User and all associated articles were deleted successfully.'
    redirect_to root_path
  end

  private

  # 1.  Recall that the http GET function passes to the Controller the current user
  #     (from the browser) in the URI given by user/id
  #     Rails passes this argument in the form of the params hash, so we can get the id by
  #     referring to params[:id]
  # 2.  Use an instance variable, which in this case is an object, as Rails makes it
  #     available to the View for us
  def set_user
    @user = User.find(params[:id])
  end

  def whitelist_user_params
    params.require(:user).permit(:username, :email_address, :password)
  end

  def require_same_user
    return unless current_user != @user && !current_user.admin?
    flash[:warning] = 'You can only modify your own profile'
    redirect_to @user
  end
end
