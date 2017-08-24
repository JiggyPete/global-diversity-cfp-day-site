Rails.application.routes.draw do
  devise_for :users
  resources :workshops, only: [:new, :show, :create, :edit, :update, :destroy]
  resources :invite_team_members, only: :create

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homepage#index'
end
