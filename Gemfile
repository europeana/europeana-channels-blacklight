source 'https://rubygems.org'

gem 'rails', '4.2.9'

# NB: this *must* be by Git ref; else will break asset versioning in
#     config/initializers/assets.rb, preventing app startup

gem 'europeana-styleguide', github: 'europeana/europeana-styleguide-ruby', ref: '9d4c7b3'

gem 'europeana-i18n', github: 'europeana/europeana-i18n-ruby', branch: 'develop'

# Lock Mustache at 1.0.3 because > 1.0.3 kills item page performance with the commit
# https://github.com/mustache/mustache/commit/3c7af8f33d0c3b04c159e10e73a2831cf1e56e02
# on the item display page (i.e. Portal#Show) where compiled Mustache template is
# huge (> 60 MB). Due to stache gem?
gem 'mustache', '1.0.3'

# Use a forked version of stache with downstream changes, until merged upstream
# @see https://github.com/agoragames/stache/pulls/rwd
gem 'stache', github: 'europeana/stache', branch: 'europeana-styleguide'

gem 'aasm', '~> 4.2'
gem 'blacklight', '~> 6.0.0'
gem 'acts_as_list', '~> 0.7'
gem 'cancancan', '~> 1.12'
gem 'colorize'
gem 'delayed_job_active_record', '~> 4.1'
gem 'devise', '~> 3.5.4'
gem 'europeana-api', '~> 1.0.0'
gem 'europeana-blacklight', '~> 1.0.0'
gem 'europeana-feedback-button', '0.0.4'
gem 'feedjira', '~> 2.0'
gem 'foederati', '~> 0.2.0'
gem 'fog', '~> 1.33'
gem 'globalize', '~> 5.0'
gem 'globalize-versioning', github: 'globalize/globalize-versioning'
gem 'jbuilder', '~> 2.6.0'
gem 'json_api_client'
gem 'lograge'
gem 'logstash-event'
gem 'logstash-logger'
gem 'mail', '~> 2.6.6'
gem 'nokogiri'
gem 'rails-observers'
gem 'redis', '~> 3.3.3'
gem 'rest-client', '~> 1.8.0'
gem 'ruby-oembed', '~> 0.9'
gem 'pg'
gem 'paperclip', '~> 4.3'
gem 'paper_trail', '~> 4.0'
gem 'rails_with_relative_url_root', '~> 0.1'
gem 'rack-cors'
gem 'rack-rewrite'
gem 'rails_admin', '~> 0.8.0'
gem 'redis-rails', '~> 4.0'
gem 'sass-rails'
gem 'soundcloud', '~> 0.3'
gem 'stringex', '~> 2.6'
gem 'therubyracer'
gem 'i18n_data'

group :production do
  gem 'europeana-logging', '~> 0.2.3'#, github: 'europeana/europeana-logging-ruby', branch: 'develop'
  gem 'rails_serve_static_assets'
  gem 'uglifier', '~> 2.7.2'
end

group :development, :profiling, :production do
  gem 'clockwork', '~> 1.2'
  gem 'htmlcompressor', '0.3'
  gem 'newrelic_rpm'
  gem 'puma', '~> 3.9.1'
end

group :development, :profiling, :test do
  gem 'dotenv-rails', '~> 2.0'
  gem 'rspec-rails', '~> 3.0'
  gem 'rubocop', '0.39.0', require: false # only update when Hound does
end

group :development, :profiling do
  gem 'foreman'
  gem 'redis-rails-instrumentation' # WARNING: may break with logstash, i.e. europeana-logging
end

group :development do
  gem 'spring', '~> 1.6'
end

group :profiling do
  gem 'stackprof'
end

group :test do
  gem 'capybara'
  gem 'coveralls', require: false
  gem 'phantomjs', require: 'phantomjs/poltergeist'
  gem 'poltergeist'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 3.0', require: false
  gem 'simplecov', require: false
  gem 'webmock'
end

group :doc do
  gem 'yard'
end

group :localeapp do
  gem 'localeapp', '~> 1.0'
end
