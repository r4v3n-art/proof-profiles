class User < ApplicationRecord
  validates :eth_address, presence: true, uniqueness: true
  validate :valid_eth_address?

  private
  def valid_eth_address?
    if eth_address && !Eth::Utils.valid_address?(eth_address)
      errors.add(:eth_address, I18n.t('errors.invalid_eth_address'))
    end
  end
end
