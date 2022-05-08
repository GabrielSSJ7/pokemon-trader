class HttpClient::Binance::Client < HttpClient::Base
  class << self
    def get_candles(symbol = "BTCUSDT", interval = "1d", limit = 7)
      get(url("?symbol=#{symbol}&interval=#{interval}&limit=#{limit}"))
    end

    private

    def url(path)
      ENV["BINANCE_BASE_URL"] + path
    end
  end
end

