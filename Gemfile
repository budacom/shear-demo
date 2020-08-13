source 'https://rubygems.org'

gem 'aws-sdk-s3', '~> 1.0'
gem 'bootsnap', require: false
gem 'data_migrate'
gem 'enumerize'
gem 'faraday', '~> 0.17'
gem 'faraday_middleware', '~> 0.14'
gem 'google-cloud-vision', '~> 1.0'
gem 'shear', git: 'https://github.com/budacom/shear', branch: 'refactor-name'
gem 'jbuilder', '~> 2.7'
gem 'mini_magick'
gem 'patron', '~> 0.6'
gem 'pg'
gem 'power-types'
gem 'puma', '~> 4.1'
gem 'rack-cors', '~> 1.1'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
gem 'rails-i18n'
gem 'sass-rails', '>= 6'
gem 'sidekiq'
gem 'sidekiq-scheduler', '>= 3.0.1'
gem 'strong_migrations'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

group :development do
  gem 'annotate', '~> 3.0'
  gem 'listen'
  gem 'spring'
end

group :production do
  gem 'heroku-stage'
  gem 'rack-timeout'
  gem 'rails_stdout_logging'
end

group :test do
  gem 'rspec_junit_formatter', '0.2.2'
  gem 'shoulda-matchers', require: false
end

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'guard-rspec', require: false
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-nc', require: false
  gem 'rspec-rails'
  gem 'rubocop', '~> 0.87.0'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :production, :development, :test do
  gem 'tzinfo-data'
end
