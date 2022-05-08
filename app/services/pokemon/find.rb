class Pokemon::Find
  include ::PokemonHelper

  def initialize(id)
    @id = id
  end

  def call
    pokemon = Pokemon.collection.aggregate([
      { "$match" => { "poke_id" => @id } },
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
        user_id: 1,
        picture: 1
      }}
    ]).first

    if pokemon.blank?
      pokemon = HttpClient::Pokemon::Client.get_pokemon(@id)[:body]
    end

    pokemon
  end

  def self.call(id)
    new(id).call
  end
end
