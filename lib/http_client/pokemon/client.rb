class HttpClient::Pokemon::Client < HttpClient::Base
  class << self
    def get_pokemon(id)
      get(url("/pokemon/#{id}"))
    end

    def list_pokemon(limit: limit = 20, offset: offset = 0)
      get(url("/pokemon?offset=#{offset}&limit=#{limit}"))
    end

    private

    def url(path)
      ENV['POKEMON_BASE_URL'] + path
    end
  end
end
