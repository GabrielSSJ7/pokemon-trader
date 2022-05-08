class OperationHistory::Find
  def initialize(user)
    @user = user
  end

  def call
    OperationHistory.collection.aggregate([
      {
        '$match': { 'user_id': @user[:_id] },
      },
      {
        '$lookup': {
          'from': 'users',
          'localField': 'user_id',
          'foreignField': '_id',
          'as': 'user_array',
        }
      },
      {
        '$lookup': {
          'from': 'pokemons',
          'localField': 'pokemon_id',
          'foreignField': '_id',
          'as': 'pokemon_array',
        }
      },
      {
        '$project': {
          'pokemon': { 
            name: { '$arrayElemAt': ['$pokemon_array.name', 0] },
            base_xp: { '$arrayElemAt': ['$pokemon_array.base_xp', 0] },
            price: { '$arrayElemAt': ['$pokemon_array.price', 0] },
            picture: { '$arrayElemAt': ['$pokemon_array.picture', 0] },
            btc_buy: { '$arrayElemAt': ['$pokemon_array.btc_buy', 0] },
          },
          'user': {
            name: { '$arrayElemAt': ['$user_array.name', 0] },
            username: { '$arrayElemAt': ['$user_array.username', 0] }
          },
          type: 1,
          price: 1
        }
      }
    ])
  end

  def self.call(user)
    new(user).call
  end
end
