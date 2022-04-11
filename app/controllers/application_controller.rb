class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    return unless session[:user_id]

    @current_user ||= User.find(session[:user_id])
  end

  def authenticate
    redirect_to root_url unless current_user
  end
end
