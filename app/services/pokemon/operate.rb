class Pokemon::Operate
  def initialize(poke_id, user)
    @poke_id = poke_id
    @user = user
  end

  def call
    pokemon = Pokemon.where(poke_id: @poke_id).first || Pokemon::Find.get_pokemon(@poke_id)
    if !pokemon[:user].present?
      pokemon = Pokemon.create!(
        poke_id: @poke_id,
        user: @user,
        name: pokemon[:name],
        open_to_sell: false,
        base_xp: pokemon[:base_experience],
        price: pokemon_price(pokemon[:base_experience]),
        picture: pokemon[:sprites][:other][:dream_world][:front_default]
      )
      save_history(pokemon: pokemon, seller: nil, buyer: @user)
    else
      if pokemon[:open_to_sell] && pokemon[:user_id] != @user[:_id] 
        save_history(pokemon: pokemon, seller: pokemon[:user_id], buyer: @user)
        pokemon.update!(user: @user, open_to_sell: false)
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

  def pokemon_price(base_xp)
    "%.8f" % (base_xp * ENV["POKEMON_BASE_BTC"].to_f)
  end
end
