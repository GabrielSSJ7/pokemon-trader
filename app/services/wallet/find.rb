class Wallet::Find
  include ::BinanceHelper

  def initialize(user)
    @user = user
  end

  def call
    result = Pokemon.collection.aggregate([
      {
        '$match': { 'user_id': @user[:_id] },
      },
      {
        '$group': {
          '_id': nil,
          'total': { '$sum': { '$multiply': [{'$toDouble':'$price'}, 100000000] } },
          'count': { '$sum': 1 }
        }
      }
    ]).first

    result[:total] = "%.8f" % (result[:total] / 100000000)

    candles = HttpClient::Binance::Client.get_candles
    candles_parsed = translate_candles(candles)

    result[:diff] = candles_parsed[-1][:
    
    result
  end

  def self.call(user)
    new(user).call
  end
end

