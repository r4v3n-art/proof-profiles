class SessionsController < ApplicationController
  def index
    session[:nonce] = SecureRandom.hex(10)
  end

  def create
    if valid_nonce? && valid_sig?
      #todo verify proof card in wallet of params[:address]
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
end
