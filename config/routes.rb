Rails.application.routes.draw do
  resources :saml, only: :index do
    collection do
      get :sso
      post :acs
      get :metadata
      get :logout
    end
  end
  resources :lms, only: %i[index create]
  resources :browses, only: %i[index]
  resources :views, only: %i[index]
  root 'saml#index'
end
