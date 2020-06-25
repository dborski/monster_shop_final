Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'welcome#index', as: 'root'

  get '/merchants', to: 'merchants#index'
  post '/merchants', to: 'merchants#create'
  get '/merchants/new', to: 'merchants#new'
  get '/merchants/:merchant_id/edit', to: 'merchants#edit'
  get '/merchants/:merchant_id', to: 'merchants#show', as: 'merchant'
  patch '/merchants/:merchant_id', to: 'merchants#update'
  put '/merchants/:merchant_id', to: 'merchants#update'
  delete '/merchants/:merchant_id', to: 'merchants#destroy'

  get 'merchants/:merchant_id/items', to: 'items#index'

  get '/items', to: 'items#index'
  get '/items/:id', to: 'items#show', as: 'item'

  get '/items/:item_id/reviews/new', to: 'reviews#new', as: 'new_item_review'
  post '/items/:item_id/reviews', to: 'reviews#create', as: 'item_reviews'

  get '/reviews/:id/edit', to: 'reviews#edit', as: 'edit_review'
  patch '/reviews/:id', to: 'reviews#update'
  put '/reviews/:id', to: 'reviews#update'
  delete '/reviews/:id', to: 'reviews#destroy', as: 'review'

  get '/cart', to: 'cart#show'
  post '/cart/:item_id', to: 'cart#add_item'
  delete '/cart', to: 'cart#empty'
  patch '/cart/:change/:item_id', to: 'cart#update_quantity'
  delete '/cart/:item_id', to: 'cart#remove_item'

  get '/registration', to: 'users#new', as: :registration

  post '/users', to: 'users#create'
  patch '/users/:id', to: 'users#update', as: 'user'
  put '/users/:id', to: 'users#update'

  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  get '/profile/edit_password', to: 'users#edit_password'
  post '/orders', to: 'user/orders#create'
  get '/profile/orders', to: 'user/orders#index'
  get '/profile/orders/:id', to: 'user/orders#show'
  delete '/profile/orders/:id', to: 'user/orders#cancel'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'

  namespace :merchant do
    get '/', to: 'dashboard#index', as: :dashboard
    get 'orders/:id', to: 'orders#show', as: 'order'
    get '/items', to: 'items#index'
    post '/items', to: 'items#create'
    get '/items/new', to: 'items#new', as: 'new_merchant_item'
    get '/items/:id/edit', to: 'items#edit', as: 'edit_merchant_item'
    patch '/items/:id', to: 'items#update', as: 'merchant_item'
    put '/items/:id', to: 'items#update'
    delete '/items/:id', to: 'items#destroy'
    put '/items/:id/change_status', to: 'items#change_status'
    get '/orders/:id/fulfill/:order_item_id', to: 'orders#fulfill'
    patch '/discounts/:id/enable', to: 'discounts#enable_disable'
    resources :discounts, only: [:index, :new, :create, :edit, :update, :show, :destroy]
  end

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :merchants, only: [:show, :update]
    resources :users, only: [:index, :show]
    patch '/orders/:id/ship', to: 'orders#ship'
  end
end
