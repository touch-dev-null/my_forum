require 'rails_helper'

module MyForum
  RSpec.describe User, type: :model do
    describe 'User password' do
      it 'should save user with password' do
        user = User.new
        user.password = 'test'
        expect(user.save).to eq(true)
      end
    end
  end
end
