Rails.application.routes.draw do
  get 'prospects/list'
  get 'prospects/selected'
  get 'prospects/custcode'
  get 'prospects/chosen'
  get 'prospects/inactive'
  get 'prospects/customer'
  get 'prospects/search'
  get 'prospects/find'
  resources :prospects do
    resources :prospect_calls, except: [:index, :show]
  end
  devise_for :user2s, controllers: { registrations: "user2s/registrations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'prospects#index'
end
