class SessionsController < ApplicationController
  def index
    session[:nonce] = SecureRandom.hex(10)
  end

  def create
    if valid_nonce? && valid_sig? && is_proof_member?
      render plain: 'successful login'
    else
      head 401
    end
  end

  private
  def valid_nonce?
    nonce = params[:message][/.*<([^>]*)/,1]
    nonce == session[:nonce]
  end

  def valid_sig?
    recovered_key = Eth::Key.personal_recover(
      params[:message].delete("\r"), params[:sig]
    )

    Eth::Utils.public_key_to_address(recovered_key) == params[:address]
  end

  def is_proof_member?
    service = EtherscanService.new(api_key: Rails.application.credentials.etherscan.api_key)
    service.is_proof_member?(params[:address])
  end
end
