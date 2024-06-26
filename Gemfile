source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

# Environment variables
gem 'dotenv', '~> 2.1', '>= 2.1.1'
# Ensure our .env variables are loaded before all dependcies that use them
gem 'dotenv-rails', require: 'dotenv/rails-now'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.6'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Searchkick client for elasticsearch
gem 'searchkick', '~> 5.0.2'
# Elasticsearch for message indexing
gem 'elasticsearch', "~> 7.17.1"
# Soft deletes
#gem 'discard', '~> 0.1.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Redlock implements a distributed lock algorithm for Redis to avoid race conditions
gem 'redlock'
# Better performance for Redis
gem 'hiredis', '~> 0.6.1'
# Sidekiq for jobs
gem 'sidekiq'
gem 'sidekiq-client-cli'
#gem 'sidekiq-unique-jobs', '~> 6.0.0'
# Cron jobs
gem 'whenever', require: false
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # To generate arbitrary data
  gem 'faker', '~> 2.20'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
