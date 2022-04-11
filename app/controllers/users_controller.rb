class UsersController < ApplicationController
  before_action :authenticate
  before_action :authorize, only: [:edit, :update]
  before_action :find_user, except: :index

  def index
    @users = User.all
  end

  def show;end

  def edit;end

  def update
    if @user.update(user_params)
      redirect_to users_path
    else
      render 'edit'
    end
  end

  private

  def authorize
    head 401 if params[:address] != current_user.eth_address
  end

  def user_params
    params.require(:user).permit(:bio)
  end

  def find_user
    @user = User.find_by(eth_address: params[:address])
  end
end
