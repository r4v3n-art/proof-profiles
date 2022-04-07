require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }
    it { should validate_presence_of(:eth_address) }
    it { should validate_uniqueness_of(:eth_address) }
  end
end
