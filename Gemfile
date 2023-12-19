source 'https://rubygems.org'

ruby '3.2.2'

gem 'devise', '~> 4.9'
gem 'jwt'
gem "rack-cors", "~> 2.0"

gem 'httparty', '~> 0.21.0'
gem 'nokogiri', '~> 1.15', '>= 1.15.5'
gem 'rails', '~> 7.1.2'
gem 'sprockets-rails'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis', '>= 4.0.1'
# gem 'kredis'
# gem 'bcrypt', '~> 3.1.7'
gem 'tzinfo-data', platforms: %i[ windows jruby ]
gem 'bootsnap', require: false
gem "sidekiq", "~> 7.2"
# gem 'image_processing', '~> 1.2'

group :development, :test do
  gem 'debug', platforms: %i[ mri windows ]
  gem 'byebug'
  gem 'bundler-audit', '~> 0.9.1'
  gem 'dotenv-rails'
  gem 'brakeman', '~> 6.1'
  gem 'rubocop', '~> 1.59'
  gem 'rubocop-rails', '~> 2.22'
  gem 'ruby_audit', '~> 2.2'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'webmock'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'database_cleaner-active_record'
end

group :development do
  gem 'web-console'
  gem 'rack-mini-profiler'
  # gem 'spring'
end
