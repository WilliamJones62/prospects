Rails.application.routes.draw do
  resources :prospects
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'prospects#index'
end
