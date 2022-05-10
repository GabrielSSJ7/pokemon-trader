class Pokemon::Operate
  include ::PokemonHelper
  include ::BinanceHelper

  def initialize(poke_id, user)
    @poke_id = poke_id
    @user = user
  end

  def call
    pokemon = Pokemon.where(poke_id: @poke_id).first || Pokemon::Find.call(@poke_id)
    if !pokemon[:user].present?
      pokemon = Pokemon.create(
        poke_id: @poke_id,
        user: @user,
        name: pokemon[:name],
        open_to_sell: false,
        base_xp: pokemon[:base_experience],
        price: pokemon_price(pokemon[:base_experience]),
        picture: pokemon[:sprites][:other][:dream_world][:front_default],
        btc_buy_price: get_btc_today_candle
      )
      save_history(pokemon: pokemon, seller: nil, buyer: @user)
    else
      if pokemon[:open_to_sell] && pokemon[:user_id] != @user[:_id] 
        save_history(pokemon: pokemon, seller: pokemon[:user_id], buyer: @user)
        pokemon.update!(user: @user, open_to_sell: false, btc_buy_price: get_btc_today_candle)
      else
        result = { error: "Pokemon is not open to trade" }
      end
    end

    return result if result
    pokemon
  end

  def self.call(poke_id, user)
    new(poke_id, user).call
  end

  private

  def save_history(pokemon:, seller:, buyer:)
    OperationHistory::Create.call(buyer, pokemon, :buy, pokemon[:price])

    if seller
      OperationHistory::Create.call(seller, pokemon, :sell, pokemon[:price])
    end
  end

  def get_btc_today_candle
    candles = HttpClient::Binance::Client.get_candles(
      symbol: "BTCUSDT",
      interval: "1d",
      limit: 1
    )
    candles.first[:close]
  end
end
