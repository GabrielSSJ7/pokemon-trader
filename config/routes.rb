Rails.application.routes.draw do
  namespace :v1 do
    namespace :auth do
      post '/login', to: 'authentication#login'
    end

    namespace :users do
      post '/', action: :create
    end
  end
end
