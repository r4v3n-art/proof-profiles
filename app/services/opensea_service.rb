require 'net/http'
require 'json'


class OpenSeaService

  def initialize(api_key:)
    @key = api_key
  end

  def get_data_by_address(address:)
    uri = URI('https://api.opensea.io/api/v1/assets')

    nextCursor = ''
    userAssets = []

    while nextCursor

      params = {
        owner: address,
        limit: '50',
        cursor: nextCursor
      }

      uri.query = URI.encode_www_form(params)
      req = Net::HTTP::Get.new(uri)
      req['X-API-Key'] = key

      res = Net::HTTP.start(uri.hostname, uri.port,
        :use_ssl => uri.scheme == 'https') {|http|
        http.request(req)
      }

      data = JSON.parse(res.body)

      nextCursor = data.dig('next')
      #prevCursor = data.dig('previous')

      assets = data.dig('assets')

      userAssets += assets

      sleep 0.2
    end

  userAssets
  end

  private
  attr_reader :key
end
