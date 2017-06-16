Rails.application.routes.draw do
  resources :saml, only: :index do
       collection do
           get :sso
           post :acs
           get :metadata
           get :logout
         end
     end
  resources :pages, only: :index
  get :pages_browse, to: 'pages#browse'
  root 'saml#sso'
end
