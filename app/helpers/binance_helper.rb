module BinanceHelper
  def translate_candles(candles)
    candles.map do |candle| 
      {
        time: candle[0],
        open: candle[1],
        high: candle[2],
        low: candle[3],
        close: candle[4],
        volume: candle[5]
      }
    end
  end
end
