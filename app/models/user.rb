class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  has_secure_password

  field :name, type: String
  field :username, type: String
  field :password_digest, type: String

  validates :username, presence: true, uniqueness: true

  has_many :pokemon
  has_many :operation_history
end
