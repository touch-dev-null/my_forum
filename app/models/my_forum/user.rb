module MyForum
  class User < ActiveRecord::Base
    require 'digest'

    has_many :posts, class_name: 'MyForum::Post'
    has_many :attachments
    has_many :user_roles
    has_many :roles, through: :user_roles
    has_many :user_group_links
    has_many :user_groups, through: :user_group_links

    has_one :avatar

    scope :online, -> { where("updated_at > ?", 10.minutes.ago) }
    scope :today_visited, -> { where("updated_at > ?", Time.now.beginning_of_day) }

    enum gender: [:female, :male, :alien]
    serialize :additional_info


    validates_uniqueness_of :login, :email

    before_save :encrypt_password

    def valid_password?(submitted_password)
      password == encrypt(submitted_password)
    end

    private

    def encrypt_password
      return unless password_changed?

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
