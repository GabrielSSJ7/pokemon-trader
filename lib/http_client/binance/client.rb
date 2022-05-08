class HttpClient::Binance::Client < HttpClient::Base
  class << self
    include ::BinanceHelper

    def get_candles(symbol:, interval:, limit:)
      candles = get(url("?symbol=#{symbol}&interval=#{interval}&limit=#{limit}"))
      translate_candles(candles[:body])
    end

    private

    def url(path)
      ENV["BINANCE_BASE_URL"] + path
    end
  end
end

