require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }
    it { should validate_presence_of(:eth_address) }
    it { should validate_uniqueness_of(:eth_address) }

    it 'should validate ETH address' do
      user = build(:user, eth_address: 'fdafds')

      expect(user.valid?).to be(false)
      expect(user.errors.messages).to eq({ eth_address: [I18n.t('errors.invalid_eth_address')] })
    end
  end
end
