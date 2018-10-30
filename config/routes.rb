Rails.application.routes.draw do
  get 'prospects/selected'
  resources :prospects do
    resources :prospect_calls, except: [:index, :show]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { registrations: "users/registrations" }
  root 'prospects#index'
end
