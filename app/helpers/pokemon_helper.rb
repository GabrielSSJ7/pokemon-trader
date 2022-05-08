module PokemonHelper
  def pokemon_price(base_xp)
    "%.8f" % (base_xp * ENV["POKEMON_BASE_BTC"].to_f)
  end
end
