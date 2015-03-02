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
        session[:user_id] = user.id
        expect(user.valid_password?('12345678')).to be true

        post :forgot_password, user: { email: 'demo@example.com'}
        expect(user.reload.valid_password?('12345678')).to be false

        last_delivery = ActionMailer::Base.deliveries.last
        new_password = last_delivery.text_part.body.decoded.split(' ').last
        expect(user.reload.valid_password?(new_password)).to be true
      end
    end

    describe "#edit" do
      before :each do
        @user = User.create!(login: 'demo', password: '12345678', email: 'demo@example.com')
        session[:user_id] = @user.id
      end

      it 'should not change password' do
        patch :update, id: @user.id, user: {email: 'abc@google.com', password: ''}
        expect(@user.reload.valid_password?('12345678')).to be true
        expect(@user.reload.email).to eq('abc@google.com')
      end

      it 'should not change password if old password not given' do
        patch :update, id: @user.id, user: {email: 'abc@google.com', password: 'new_password'}
        expect(@user.reload.valid_password?('new_password')).to be false
      end

      it 'should update user with password' do
        expect(@user.reload.valid_password?('12345678')).to be true
        patch :update, id: @user.id, user: {email: 'abc@google.com', password: '12345678', new_password: 'new_password'}
        expect(@user.reload.valid_password?('new_password')).to be true
        expect(@user.reload.email).to eq('abc@google.com')
      end
    end

    describe "#create" do
      it 'should create new user' do
        post :create, user: {email: 'new_user@google.com', password: 'new_user_pass', login: 'new_user'}
        user = User.find_by_email('new_user@google.com')
        expect(user.login).to eq('new_user')
        expect(user.valid_password?('new_user_pass')).to be true
      end
    end
  end
end
