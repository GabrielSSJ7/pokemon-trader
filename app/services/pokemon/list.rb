class Pokemon::List
  include ::PokemonHelper
  include ::BinanceHelper

  def initialize(limit, offset)
    @limit = limit
    @offset = offset
  end

  def call
    pokemon_api =  HttpClient::Pokemon::Client.list_pokemon(
                limit: @limit, 
                offset: @offset || "0"
               )
    pokemons = fetch_all_pokemons(pokemon_api[:body][:results])
    pokemons = concat_pokemons_owners(pokemons)
    pokemons = pokemon_valuation(pokemons)
    pokemons
  end

  def self.call(limit, offset)
    new(limit, offset).call
  end

  private

  def fetch_all_pokemons(pokemon_api)
    pokemons = []
    pokemon_api.each do |pokemon|
      pokemons << map_pokemon(HttpClient::Base.get(pokemon[:url])[:body])
    end

    pokemons
  end

  def map_pokemon(pokemon)
    {
      name: pokemon[:name],
      base_xp: pokemon[:base_experience],
      picture: pokemon[:sprites][:other][:dream_world][:front_default],
      poke_id: pokemon[:id].to_s,
      price: pokemon_price(pokemon[:base_experience])
    }
  end

  def concat_pokemons_owners(pokemons)
    result = []
    pokemons.each do |pokemon|
      pokemon_db = Pokemon.where(poke_id: pokemon[:poke_id]).first
      if pokemon_db.present?
        result << get_entire_data(pokemon[:poke_id])
      else
        result << pokemon
      end
    end
    result
  end

  def get_entire_data(poke_id)
    pokemon_db = Pokemon.collection.aggregate([
      { '$match': { poke_id: poke_id } },
      {'$lookup' => {
        from: 'users',
        localField: 'user_id',
        foreignField: '_id',
        as: 'user_array'
        }},
      {'$project' => {
        _id: 1,
        name: 1,
        base_xp: 1,
        price: 1,
        user: { 
          name: { '$arrayElemAt': ['$user_array.name', 0] },
          username: { '$arrayElemAt': ['$user_array.username', 0] },
        },
        poke_id: 1,
        open_to_sell: 1,
        user_id: 1,
        picture: 1,
        btc_buy_price: 1,
      }}
    ]).first
  end

  def pokemon_valuation(pokemons)
    result = []
    candle = HttpClient::Binance::Client.get_candles(
      symbol: "BTCUSDT",
      interval: "1d",
      limit: 1
    ).first
    
    pokemons.each do |pokemon|
      if pokemon[:btc_buy_price].present?
        xy = candle[:close].to_f - pokemon[:btc_buy_price].to_f         
        xy2 = pokemon[:btc_buy_price].to_f + candle[:close].to_f / 2

        puts "buy: #{pokemon[:btc_buy_price]} - candle close: #{candle[:close]}"

        pokemon[:valuation] = (xy / xy2) * 100
      end
      result << pokemon
    end
    result
  end
end

