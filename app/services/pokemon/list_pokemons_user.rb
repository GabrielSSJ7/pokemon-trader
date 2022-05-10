class Pokemon::ListPokemonsUser

  def initialize(user)
    @user = user
  end

  def call
    pokemons = get_pokemons
    pokemon_valuation(pokemons)
  end

  def self.call(user)
    new(user).call
  end

  private

  def pokemon_valuation(pokemons)
    result = []
    candles = HttpClient::Binance::Client.get_candles(
      symbol: "BTCUSDT",
      interval: "1d",
      limit: 2
    )
    
    pokemons.each do |pokemon|
      if pokemon[:btc_buy_price].present?
        xy = candles[0][:close].to_f - pokemon[:btc_buy_price].to_f         
        xy2 = pokemon[:btc_buy_price].to_f + candles[0][:close].to_f / 2
        pokemon[:valuation] = (xy / xy2) * 100
      else
        xy = candles[1][:close].to_f - candles[0][:close].to_f
        xy2 = candles[0][:close].to_f + candles[1][:close].to_f / 2
        pokemon[:valuation] = (xy / xy2) * 100
      end

      pokemon[:usd] = pokemon[:price].to_f * candles[0][:close].to_f
      result << pokemon
    end
    result
  end
  
  def get_pokemons
    Pokemon.collection.aggregate([
      { '$match': { user_id: @user[:_id] } },
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
    ])
  end

end

