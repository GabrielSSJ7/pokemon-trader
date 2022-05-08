class Pokemon
  include Mongoid::Document
  include Mongoid::Timestamps
  field :poke_id, type: String
  field :name, type: String
  field :base_xp, type: Integer
  field :price, type: String
  field :btc_buy_price, type: String
  field :picture, type: String
  field :open_to_sell, type: Boolean, default: true

  validates :poke_id, presence: true, uniqueness: true

  belongs_to :user
  has_many :operation_history
end
