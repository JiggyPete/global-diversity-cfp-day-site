Rails.application.routes.draw do
  devise_for :users
  resources :events, only: :show

  post "/workshop/duplicate" => "workshops#duplicate"
  resources :workshops, only: [:new, :show, :create, :edit, :update, :destroy]
  resources :users, only: [:destroy]

  resources :cfps
  resources :incidents
  resources :schedule, only: :index
  resources :email_templates, only: :index
  resources :preparation, only: :index
  resources :blog, only: :index
  resources :invite_team_members, only: :create
  resources :account, only: [:edit, :update]
  resources :proposals, only: [:index, :show]

  namespace :admin do
    resources :workshops, only: :index
  end

  match 'code-of-conduct', to: "code_of_conduct#index", via: :get
  match 'organise', to: "organise#index", via: :get
  match 'mailing-list-sign-up', to: "mailchimp#index", via: :get

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homepage#index'
end
