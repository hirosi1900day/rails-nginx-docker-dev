require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  xit '確認' do
    expect(user).to eq user
  end
end