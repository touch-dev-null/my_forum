module MyForum
  class User < ActiveRecord::Base
    require 'digest'

    has_many :posts, class_name: 'MyForum::Post'
    has_many :user_roles
    has_many :roles, through: :user_roles

    before_save :encrypt_password

    def valid_password?(submitted_password)
      password == encrypt(submitted_password)
    end

    def can_quick_answer?(forum)
      true
    end

    private

    def encrypt_password
      self.salt = make_salt unless valid_password?(password)
      self.password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
  end
end
