# frozen_string_literal: true

# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
#
Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "articles#index"

  # The controller is called "pages" (actually pages.controller.rb) and the
  # action to be invoked is call home , so the pages controller needs a method called home
  #     root 'articles#index'
  root 'pages#home'

  # Adding an About (static) page:
  # The below maps the uri provided by the  Rails Get action to the controller given by
  # "pages" and the "about" action within that contoller
  get 'about', to: 'pages#about'

  # Provides the basic CRUD routes [from base class] for articles
  # To expose the routes incrementally or as a subset, use the ",only" modifier.
  # resources :articles, only: %i[show index new create edit update destroy]
  # Expose all routes of the articles resource
  #
  # Expose the routes for comments as nested by resources.
  # This relfects the 1:many relationship and Rails will provide the parent article with each
  # comment route
  resources :articles do
    resources :comments
  end

  # Routes for User actions
  get 'signup', to: 'users#new'

  # The form_with statement in users/_form.html.erb needs to know where to post
  # the form.  Since we pass it model: @user, it looks for users_path.
  # Since the form is invoked by the "new" method we complete the new user creation
  # by sending the form's data to the create method:
  # post 'users', to: 'users#create'
  # Alternatively, the resources statement assigns all the standard routes.  But we
  # want the "new" method to be invoked by signup [as above] so we can omit it from the
  # resources statement
  resources :users, except: [:new]

  # Login actions - to be managed by the sessions controller
  #  1.  Login validation
  get 'login', to: 'sessions#new'
  #
  # 2.  Create a session based on successful login.
  #     Recall the HTTP verb "post" denotes creation of a new resource
  post 'login', to: 'sessions#create'
  #
  # 3. Logout and thus delete a user session
  delete 'logout', to: 'sessions#destroy'
  #
  # ----  Routes for categories
  resources :categories
end
