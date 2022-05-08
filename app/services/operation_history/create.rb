class OperationHistory::Create
  def initialize(user, pokemon, type, price)
    @user = user
    @pokemon = pokemon
    @type = type
    @price = price
  end

  def call
    OperationHistory.create!(
      user: @user,
      pokemon: @pokemon,
      type: @type,
      price: @price
    )
  end

  def self.call(user, pokemon, type, price)
    new(user, pokemon, type, price).call
  end
end
