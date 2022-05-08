class Wallet
  include Mongoid::Document
  include Mongoid::Timestamps
  field :amount, type: String
  field :asset, type: String

  belongs_to :user
end
