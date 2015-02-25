require 'rails_helper'

module MyForum
  RSpec.describe UsersController, type: :controller do
    routes { MyForum::Engine.routes }

    describe 'Loggin in' do
      it 'should login user by password' do
        user = User.create!(login: 'demo', password: '12345678', email: 'demo@example.com')

        post :signin, user: { login: 'demo', password: '12345678' }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
      end

      it 'should not login user if login or password incorrect' do
        post :signin, user: { login: '', password: '' }
        expect(response).to render_template(:signin)
        expect(session[:user_id]).to eq(nil)

        post :signin, user: { login: 'wrong', password: 'credentials' }
        expect(response).to render_template(:signin)
        expect(session[:user_id]).to eq(nil)
      end
    end

    describe "#forgot_password" do
      it 'should send new generated password for user' do
        user = User.create!(login: 'demo', password: '12345678', email: 'demo@example.com')
        expect(user.valid_password?('12345678')).to be true

        post :forgot_password, user: { email: 'demo@example.com'}
        expect(user.reload.valid_password?('12345678')).to be false

        last_delivery = ActionMailer::Base.deliveries.last
        new_password = last_delivery.text_part.body.decoded.split(' ').last
        expect(user.reload.valid_password?(new_password)).to be true
      end
    end
  end
end
