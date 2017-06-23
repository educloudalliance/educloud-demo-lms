Rails.application.routes.draw do
  resources :saml, only: :index do
    collection do
      get :sso
      post :acs
      get :metadata
      get :logout
    end
  end
  resources :pages, only: %i[index create]
  get :pages_browse, to: 'pages#browse'
  get :pages_view, to: 'pages#view'
  root 'saml#sso'
end
