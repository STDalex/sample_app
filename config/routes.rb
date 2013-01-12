SampleApp::Application.routes.draw do

resources :users, only: [:index] do
  resources :microposts, only: [:index]
end

resources :users 
resources :sessions, only: [:new, :create, :destroy]
resources :microposts, only: [:create, :destroy]



  match '/contact', to: 'pages#contact'
  match '/about', to: 'pages#about'
  match '/help', to: 'pages#help'
  match '/signup', to: 'users#new'
  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy'
  match '/edit', to: 'user#edit'
  root to: 'pages#home'

end