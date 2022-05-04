module ApplicationHelper
  def encode(payload)
    JWT.encode(payload, ENV["SECRET_KEY"])
  end

  def decode(token)
    decoded = JWT.decode(token, ENV["SECRET_KEY"])[0]
    HashWithIndifferentAccess.new decoded
  end
end
