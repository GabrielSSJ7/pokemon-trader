Rails.application.routes.draw do
  namespace :v1 do
    namespace :auth do
      post 'login', to: 'authentication#login'
      get 'verify', to: 'authentication#verify'
    end

    namespace :users do
      post '/', action: :create
      get '/pokemons', action: :pokemons
    end

    namespace :pokemons do
      get '/:id', action: :show
      get '/', action: :index
      post '/operate/:id', action: :operate
      put '/toggle/:id/:type', action: :toggle
    end

    namespace :operations_history do
      get '/', action: :index
    end

    namespace :wallet do
      get '/', action: :show
    end

  end
end
