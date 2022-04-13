class User < ApplicationRecord
  paginates_per 50

  has_one_attached :pfp do |attachable|
    attachable.variant :grid, resize_to_limit: [500, 500]
  end

  validates :eth_address, presence: true, uniqueness: true
  validates :bio, length: { maximum: 140 }
  validates :name, length: { maximum: 60 }
  validates :twitter_username, length: { maximum: 20 }
  validates :discord_username, length: { maximum: 20 }
  validate :valid_eth_address?

  before_create :checksum_address

  private
  def valid_eth_address?
    if eth_address && !Eth::Utils.valid_address?(eth_address)
      errors.add(:eth_address, I18n.t('errors.invalid_eth_address'))
    end
  end

  def checksum_address
    self.eth_address = Eth::Utils.format_address(eth_address)
  end
end
