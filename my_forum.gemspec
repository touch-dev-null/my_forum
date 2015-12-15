$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "my_forum/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "my_forum"
  s.version     = MyForum::VERSION
  s.authors     = ["Vitaly Omelchenko"]
  s.email       = ["prosto.vint@gmail.com"]
  s.homepage    = "https://github.com/vintyara/my_forum"
  s.summary     = "Simple Forum"
  s.description = "Simple forum engine."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency 'haml'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'sass-rails'
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'will_paginate', '~> 3.0.6'
  s.add_dependency 'font-awesome-sass'
end
