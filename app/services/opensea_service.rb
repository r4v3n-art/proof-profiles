require 'net/http'
require 'json'


class OpenSeaService

  def initialize(api_key:)
    @key = api_key
  end

  def get_data_by_address(address:)
    uri = URI('https://api.opensea.io/api/v1/assets')

    next_cursor = ''
    assets = []

    while next_cursor

      params = {
        owner: address,
        limit: '50',
        cursor: next_cursor
      }

      uri.query = URI.encode_www_form(params)
      req = Net::HTTP::Get.new(uri)
      req['X-API-Key'] = key

      res = Net::HTTP.start(uri.hostname, uri.port,
        :use_ssl => uri.scheme == 'https') {|http|
        http.request(req)
      }

      data = JSON.parse(res.body)

      next_cursor = data['next']
      #prev_cursor = data['previous']

      res_assets = data['assets']

      assets += res_assets

      sleep 0.2
    end

  assets
  end

  private
  attr_reader :key
end
