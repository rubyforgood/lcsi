require 'sidekiq/web'

Rails.application.routes.draw do
  get 'sessions/new'

  resources :submissions

  mount Sidekiq::Web => '/sidekiq'

  namespace 'admin' do
    resource 'contest'
    put 'contest/start',  to: 'contests#start', as: :start_contest

    get 'scoreboard' => 'scoreboard#show', as: :contest_scoreboard

    resources :problems

    resources :attachments, only: [:destroy]

    resources :accounts, only: [:index, :new, :create]
  end

  resources :problems, only: [:index, :show]

  resources :attachments, only: [:show]

  resources :sessions, only: [:new, :create, :destroy]
  get 'login',  to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'

  get "/admin" => redirect("/admin/contest")

  root to: 'problems#index'
end
