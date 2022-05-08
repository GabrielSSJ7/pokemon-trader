class OperationHistory
  include Mongoid::Document
  include Mongoid::Timestamps
  field :type, type: String
  field :price, type: String

  belongs_to :user
  belongs_to :pokemon
end
