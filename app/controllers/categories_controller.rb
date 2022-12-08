# frozen_string_literal: true

# This is the controller for the categories resource
class CategoriesController < ApplicationController
  # before_action :require_admin, except: %i[index show]
  before_action :logged_in?, except: %i[index show]

  def new
    # Create a new category object immediately upon entry of this method so that
    # a valid category object exists when the Show etc. pages are first entered.
    # Otherwise, the error trapping done there will fail
    @category = Category.new
  end

  def create
    @category = Category.new(whitelist_category_params)

    if @category.save
      # Generate a confirmation message for the user.
      flash[:notice] = 'Category was created successfully.'
      redirect_to categories_path

    else
      # Error trapping
      # Re-render the "new" category page.
      # Because the save returned false, the error trapping on the "new" page
      # will display the errors
      render 'new', status: :unprocessable_entity

    end
  end

  def show
    # Instantiate the current category as passed from the browser via the Index page
    @category = Category.find(params[:id])
    # In preparation for the category show page, get a list of the articles in this category.
    # Note @articles, here, is an array, not an object
    @articles = @category.articles.paginate(page: params[:page], per_page: 5)
                         .order('created_at DESC')
  end

  def index
    # Utilizing the will_paginate gem to include pagination as this code was
    # @categories= Category.all, which could return many rows
    @categories = Category.paginate(page: params[:page], per_page: 16).order('name ASC')
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    # Instantiate the current category as passed from the browser via the Edit page
    @category = Category.find(params[:id])

    if @category.update(whitelist_category_params)
      #
      # Generate a confirmation message for the user.
      flash[:notice] = 'Category was updated successfully.'

      # Now that the category is updated, we need to tell Rails what to do.
      redirect_to category_path

    else

      # Error trapping
      # Re-render the "edit" article page.
      # Because the save returned false, the error trapping on the "edit" page
      # will display the errors
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    # Instantiate the current category as passed from the browser
    @category = Category.find(params[:id])

    if @category.destroy
      #
      # Generate a confirmation message for the user.
      flash[:notice] = 'Category was deleted successfully.'

      # Now that the article is deleted, we need to tell Rails what to do.
      # Convention would take the user to the articles list page
      #
      # Note:  We knew that the path to the articles listing page is articles_path because
      # from $rails routes --expanded we see:
      # [ Route 3 ]-----------------------------------------------------------------
      # Prefix            | articles  <-- Therefore the path is articles_path
      # Verb              | GET
      # URI               | /articles(.:format)
      # Controller#Action | articles#index

      redirect_to categories_path

    else

      # Error trapping
      # Re-render the "edit" article page.
      # Because the save returned false, the error trapping on the "edit" page
      # will display the errors
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def whitelist_category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    if logged_in? && @current_user.admin
      true
    else
      flash[:alert] = 'Categories can only be created by Admin-level users'
      redirect_to categories_path
    end
  end
end
