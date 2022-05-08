class HttpClient::Base
  class << self
    def get(url, params = {})
      request(:get, url, params)
    end

    def post(url, params = {})
      request(:post, url, params)
    end

    def put(url, params = {})
      request(:put, url, params)
    end

    private

    def request(method, url, params)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP.const_get(method.to_s.capitalize).new(uri.request_uri)
      response = http.request(request)
      build_response(response: response, 
                     url: url, 
                     params: params, 
                     method: method)
    end

    def build_response(params = {})
      {
        request: { method: params[:method],
                   url: params[:url],
                   params: params[:params]
                 }, 
        status: params[:response].code,
        body: parse_json(params[:response].body),
        headers: params[:response].each_header.to_h
      }
    end

    def parse_json(json)
      JSON.parse(json, symbolize_names: true)
    rescue JSON::ParserError
      json.squish
    end
  end
end
