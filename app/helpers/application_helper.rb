module ApplicationHelper
  def name_or_address(user)
    user.name.presence || user.eth_address
  end
end
