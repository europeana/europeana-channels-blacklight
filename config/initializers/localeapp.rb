# frozen_string_literal: true

if ENV['LOCALEAPP_API_KEY']
  require 'localeapp/rails'

  Localeapp.configure do |config|
    config.api_key = ENV['LOCALEAPP_API_KEY']
    config.sending_environments = []
    config.polling_environments = []
    config.reloading_environments = []
  end
end
