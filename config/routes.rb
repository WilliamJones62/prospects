Rails.application.routes.draw do
  get 'prospects/list'
  get 'prospects/selected'
  get 'prospects/custcode'
  get 'prospects/chosen'
  get 'prospects/inactive'
  get 'prospects/summary'
  resources :prospects do
    resources :prospect_calls, except: [:index, :show]
  end
  devise_for :users, controllers: { registrations: "users/registrations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'prospects#index'
end
