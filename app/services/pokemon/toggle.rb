class Pokemon::Toggle
  def initialize(poke_id, user, type)
    @poke_id = poke_id
    @user = user
    @type = type
  end

  def call
    pokemon = Pokemon.where(poke_id: @poke_id).first
    return {:error => "Pokemon not found"} if pokemon.nil?

    if pokemon.user_id != @user.id
      return {:error => "Pokemon not found"}
    end

    if pokemon.open_to_sell == @type
      return {:error => "Pokemon is already open to sell"}
    end

    pokemon.update!(open_to_sell: @type)
    return {:success => "Pokemon open to sell"}
  end

  def self.call(poke_id, user, type)
    new(poke_id, user, type).call
  end
end
