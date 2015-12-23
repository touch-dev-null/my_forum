module MyForum
  class Engine < ::Rails::Engine
    isolate_namespace MyForum

    require 'jquery-rails'
    require 'bootstrap-sass'

    config.after_initialize do
      ActionView::Base.sanitized_allowed_tags = %w(strong em a img br p i pre div span iframe)
      ActionView::Base.sanitized_allowed_attributes = %w(href title class src width height)
    end

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.assets false
      g.helper false
    end

    USE_CUSTOM_USER_MODEL       = false
    CUSTOM_USER_CLASS           = 'User'
    CUSTOM_USER_LOGIN_ATTR      = 'login'
    CUSTOM_USER_PASSWORD_ATTR   = 'password'
    CUSTOM_AUTHENTICATE_METHOD  = 'users#authenticate'

    attr_accessor :use_custom_user_model, :custom_user_class, :custom_user_login_attr, :custom_user_password_attr,
                  :custom_authenticate_method

    def initialize
      self.use_custom_user_model      = USE_CUSTOM_USER_MODEL
      self.custom_user_class          = CUSTOM_USER_CLASS
      self.custom_user_login_attr     = CUSTOM_USER_LOGIN_ATTR
      self.custom_user_password_attr  = CUSTOM_USER_PASSWORD_ATTR
      self.custom_authenticate_method = CUSTOM_AUTHENTICATE_METHOD
    end
  end
end
