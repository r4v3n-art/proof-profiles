class SessionsController < ApplicationController
  def index
    if current_user
      redirect_to users_path
    else
      session[:nonce] = SecureRandom.hex(10)
    end
  end

  def create
    if valid_nonce? && valid_sig? && is_proof_member?
      user = User.find_or_initialize_by(eth_address: params[:address])

      if user.persisted?
        session[:user_id] = user.id

        redirect_to users_path
      else
        user.save
        session[:user_id] = user.id

        redirect_to edit_user_path(user)
      end
    else
      render plain: 'no proof pass detected', status: :unauthorized
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
