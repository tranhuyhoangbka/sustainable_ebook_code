Rails.application.routes.draw do
  # resources :widgets
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :widgets, only: [:index, :show, :new, :create, :edit]
  resources :widget_ratings, only: [:create]
  # rails routes -g customer_service -E
  namespace :customer_service do
    resources :widgets, only: [:show, :update, :destroy]
  end
  get "manufacturer/:id", to: "manufacturers#show"

  if Rails.env.development?
    resources :design_system_docs, only: :index
  end


  ####
  # Custom routes start here
  #
  # For each new custom route:
  #
  # * Be sure you have the canonical route declared above
  # * Add the new custom route below the existing ones
  # * Document why it's needed
  # * Explain anything else non-standard
  # Used in podcast ads for the 'amazing' campaign
  get '/amazing', to: redirect("/widgets")
end
