class User
  has_secure_password

  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :username, type: String
  field :password_digest, type: String
  
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
end
