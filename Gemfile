source "https://rubygems.org"

ruby "3.3.1"
gem "rails", "~> 7.1.3", ">= 7.1.3.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

gem 'redis', '~> 5.2'
gem 'sidekiq', '~> 7.2', '>= 7.2.4'
gem 'sidekiq-scheduler', '~> 5.0', '>= 5.0.3'

gem 'guard'
gem 'guard-livereload', require: false


group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem 'rspec-rails', '~> 6.1.0'
end

gem "spring", "~> 4.4", :group => :development

gem "spring-commands-rspec", "~> 1.0", :group => :development

gem "dotenv", "~> 3.2", :groups => [:development, :test]

gem "rubocop", "~> 1.84", :group => [:development, :test]

gem "ruby-lsp", "~> 0.26.7", :group => :development

gem "factory_bot_rails", "~> 6.5", :groups => [:development, :test]

gem "faker", "~> 3.6", :groups => [:development, :test]

gem "overmind", "~> 2.5"

gem "guard-rspec", "~> 4.7", :groups => [:development, :test]

gem "simplecov", "~> 0.22.0", :groups => [:development, :test]

gem "rubycritic", "~> 5.0", :groups => [:development, :test]

gem "bundler-audit", "~> 0.9.3", :groups => [:development, :test]

gem "brakeman", "~> 8.0", :groups => [:development, :test]

gem "jbuilder", "~> 2.14"
