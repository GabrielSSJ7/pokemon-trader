Rails.application.routes.draw do
  namespace :v1 do
    namespace :auth do
      post 'login', to: 'authentication#login'
    end

    namespace :users do
      post '/', action: :create
    end

    namespace :pokemons do
      get '/:id', action: :show
      get '/', action: :index
      post '/operate/:id', action: :operate
    end

    namespace :operations_history do
      get '/', action: :index
    end

    namespace :wallet do
      get '/', action: :show
    end

  end
end
