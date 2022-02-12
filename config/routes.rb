Rails.application.routes.draw do
  #config/routes.rb
  scope "(:locale)", locale: /en|vi/ do
    root "static_page#home"
    get "users/new"
    get "static_page/home"
    get "/help",  to: "static_page#help"
    get "/about", to: "static_page#about"
    get "/contact", to: "static_page#contact"
    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "password/new", to: "password_resets#new"
    get "password/edit", to: "password_resets#edit"
    resources :users, except: %i(new)
    resources :account_activations, only: :edit
    resources :password_resets, only: [:new, :create, :edit, :update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
