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

    candles = HttpClient::Binance::Client
                                    .get_candles(
                                      symbol: 'BTCUSDT', 
                                      interval: '1d', 
                                      limit: 2)

    result[:diff] = calculate_diff(candles)
    result[:amount] = calculate_amount(result[:total], candles[0][:close])
    
    result
  end

  def self.call(user)
    new(user).call
  end

  private 

  def calculate_diff(candles)
    ((candles[0][:close].to_f - candles[1][:close].to_f) / candles[1][:close].to_f) * 100
  end

  def calculate_amount(close, amount)
    amount.to_f * close.to_f
  end
end

