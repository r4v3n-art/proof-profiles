require 'net/http'

class EtherscanService
  PROOF_CONTRACT_ADDRESS = '0x08d7c0242953446436f34b4c78fe9da38c73668d'

  def initialize(api_key:)
    @key = api_key
  end

  def is_proof_member?(address)
    response = get_token_tx_by_contract(
      contract: PROOF_CONTRACT_ADDRESS,
      address: address
    )

    transactions = response.dig('result')

    in_count = 0
    out_count = 0

    transactions.each do |transaction|
      to_address = transaction['to'].downcase
      from_address = transaction['from'].downcase

      if to_address == address.downcase
        in_count += 1
      end
      if from_address == address.downcase
        out_count += 1
      end
    end

    if in_count > out_count
      true
    else
      false
    end
  end

  def get_token_tx_by_contract(address:, contract:)
    uri = URI('https://api.etherscan.io/api')
    params = {
      apikey: key,
      address: address,
      module: 'account',
      action: 'tokennfttx',
      contractaddress: contract
    }

    uri.query = URI.encode_www_form(params)
    JSON.parse(Net::HTTP.get_response(uri).body)
  end

  private
  attr_reader :key
end
