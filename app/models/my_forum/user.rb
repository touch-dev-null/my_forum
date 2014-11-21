module MyForum
  class User < ActiveRecord::Base
    require 'digest'

    has_many :posts, class_name: 'MyForum::Post'

    before_save :encrypt_password

    def valid_password?(submitted_password)
      password == encrypt(submitted_password)
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
